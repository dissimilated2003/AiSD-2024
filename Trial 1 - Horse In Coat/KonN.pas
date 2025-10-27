//lw1 - task 23
PROGRAM KonN;
VAR
  FInName, FOutName: STRING;
  I, Len: LONGINT;
  S, T, LastS: STRING;
  Znak: SET OF CHAR;
  Del: SET OF CHAR;
  FIn, FOut: TEXT;
BEGIN
  WRITE('Входной файл: ');
  READLN(FInName);
  ASSIGN(FIn, FInName + '.txt');
  RESET(FIn);
  WRITE('Выходной файл: ');
  READLN(FOutName);
  ASSIGN(FOut, FOutName + '.txt');
  REWRITE(FOut);
  Znak := ['.', '!', '?'];
  Del := [' ', ',', ':'];
  S := '';
  T := '';
  LastS := '';
  WHILE NOT EOF(FIn)
  DO
    BEGIN
      READLN(FIn, S);
      IF S = ''
      THEN
        CONTINUE;
      I := 1;
      WHILE I <= LENGTH(S)
      DO
        BEGIN
          WHILE (S[I] IN Del) AND (T = '')
          DO
            I := I + 1;
          T := T + S[I];
          IF S[I] IN Znak
          THEN
            BEGIN
              LastS := T;
              T := ''
            END;
          I := I + 1
        END;
      T := T + ' ';
    END;
  ASSIGN(FOut, FOutName + '.txt');
  REWRITE(FOut);
  Len := LENGTH(LastS);
  IF (Len >= 4) AND (COPY(LastS, 1, 3) = 'Кто') 
  AND ((LastS[4] IN Del) OR (LastS[4] = '?')) AND (LastS[Len] = '?')
  THEN
    BEGIN
      T := 'Конь в пальто' + COPY(LastS, 4, Len - 4) + '!';
      WRITELN(Fout, T)
    END
  ELSE
    WRITELN(Fout, 'Спасибо за информацию');
  CLOSE(FIn);
  CLOSE(FOut)
END.