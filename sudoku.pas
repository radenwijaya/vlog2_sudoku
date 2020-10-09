uses crt;

var
  data: array [1..9, 1..9, 0..9] of integer;
  row, col, square: array [0..9, 0..9] of boolean;
  count, beforecount: integer;

function isrowexists(r, v: integer): boolean;
begin
  isrowexists:=row[r, v];
end;

function iscolexists(c, v: integer): boolean;
begin
  iscolexists:=col[c, v];
end;

function getVValue(r, c: integer): integer;
var vr, vc: integer;
begin
  case r of
    1..3: vr:=1;
    4..6: vr:=2;
    7..9: vr:=3;
  end;
  case c of
    1..3: vc:=1;
    4..6: vc:=2;
    7..9: vc:=3;
  end;
  getVValue:=(vr-1)*3+vc;
end;

function issquareexists(r, c, v: integer): boolean;
begin
  issquareexists:=square[getVValue(r, c), v];
end;

procedure initdata;
var r, c, i: integer;
begin
  fillchar(row, sizeof(row), 0);
  fillchar(col, sizeof(col), 0);
  fillchar(square, sizeof(square), 0);

  for r:=1 to 9 do
    for c:=1 to 9 do
      begin
        row[r, data[r, c, 0]]:=true;
        col[c, data[r, c, 0]]:=true;
        square[getVValue(r, c), data[r, c, 0]]:=true;
      end;
end;

procedure addcandidate(r, c, v: integer);
var i: integer;
begin
  for i:=1 to 9 do
    if (data[r, c, i]=0) or (data[r, c, i]=v) then
      begin
        data[r, c, i]:=v;
        break;
      end;
end;

procedure remcandidate(r, c, v: integer);
var i: integer;
  fd: boolean;
begin
  fd:=false;
  for i:=1 to 8 do
    if (fd) or (data[r, c, i]=v) then
      begin
        fd:=true;
        data[r, c, i]:=data[r, c, i+1];
      end;
  if fd then
    data[r, c, 9]:=0;
end;

procedure analyse;
var r, c, i: integer;
begin
  for r:=1 to 9 do
    begin
      for c:=1 to 9 do
        if (data[r, c, 0]=0) then
        begin
          for i:=1 to 9 do
            if not ((row[r, i]) or (col[c, i]) or
               (square[getVValue(r, c), i])) then
              begin
                addcandidate(r, c, i);
              end
            else
              begin
                remcandidate(r, c, i);
              end;
        end;
    end;
end;

procedure solve;
var r, c, i: integer;
begin
  beforecount:=count;
  for r:=1 to 9 do
    begin
      for c:=1 to 9 do
        if (data[r, c, 0]=0) then
        begin
          if (data[r, c, 2]=0) then
            begin
              count:=count-1;
              data[r, c, 0]:=data[r, c, 1];
              data[r, c, 1]:=0;
            end;
        end;
    end;
end;

var
  c, r, i: integer;
  found: boolean;
begin
  fillchar(data, sizeof(data), 0);
  clrscr;
  assign(input, 'sudo.txt');
  assign(output, 'sudo.out');
  rewrite(output);
  reset(input);
  count:=0;
  for r:=1 to 9 do
    begin
      for c:=1 to 9 do
        begin
          read(data[r, c, 0]);
          if (data[r, c, 0]=0) then
            count:=count+1;
        end;
      readln;
    end;

  repeat
    initdata;

{  for r:=1 to 9 do
    begin
      for c:=1 to 9 do
        write(row[r, c], ' ');
      writeln;
    end;
  writeln;
  for r:=1 to 9 do
    begin
      for c:=1 to 9 do
        write(col[r, c], ' ');
      writeln;
    end;
  writeln;

  for r:=1 to 9 do
    begin
      for c:=1 to 9 do
        write(square[r, c], ' ');
      writeln;
    end;
  writeln;       }

    analyse;
    solve;

    writeln('steps - count', count);
    for r:=1 to 9 do
      begin
        for c:=1 to 9 do
          write(data[r, c, 0], ' ');
        writeln;
      end;
    writeln;

    if (count=beforecount) then
    begin
      found:=false;
      for r:=1 to 9 do
        begin
          for c:=1 to 9 do
            if (data[r, c, 0]=0) then
              begin
                data[r, c, 0]:=data[r, c, 1];
                remcandidate(r, c, data[r, c, 1]);
                count:=count-1;
                found:=true;
                break;
              end;
          if found then break;
        end;
    end;
  until (count<=0) or (count=beforecount);

  if (count=beforecount) then
    begin
      writeln('unsolveable');
    end;

    for i:=0 to 9 do
  begin
    for r:=1 to 9 do
      begin
        for c:=1 to 9 do
          write(data[r, c, i], ' ');
        writeln;
      end;
    writeln;
  end;

  close(input);
  close(output);
end.
