PROGRAM HorseInCoat;
CONST
  KeyWord = 'Кто';
VAR
  Input, Output: TEXT;
  InputFile, OutputFile: STRING;
  Sentence, LetBegin: STRING;
  Flag, FlagOne, I, J: INTEGER;
  Ch, ChEnd: CHAR;
 //Основная программа
BEGIN
  WRITE('Введите входной файл: ');
  READLN(InputFile);
  ASSIGN(Input, InputFile + '.txt');
  RESET(Input);
  Flag:= 0;
  WHILE NOT EOF(Input) //сканируем на предложения
  DO
    BEGIN
      READ(Input, Ch);
      IF (Ch = '.') OR (Ch = '?') OR (Ch = '!') 
      THEN 
        BEGIN
          Flag := Flag + 1;
          ChEnd := Ch;
        END;
    END;
  RESET(Input); 
  WHILE NOT EOF(Input) // рассмотрение последнего
  DO
    BEGIN
      READ(Input, Ch);
      IF (Ch = '.') OR (Ch = '?') OR (Ch = '!') 
      THEN 
        FlagOne := FlagOne + 1;
      IF FlagOne = Flag - 1
      THEN
        BEGIN
          WHILE FlagOne <> Flag
          DO
            BEGIN
              IF EOLN(Input)
              THEN
                READLN(Input, Ch)
              ELSE
                BEGIN
                  READ(Input, Ch);
                  Sentence := Sentence + Ch;
                  IF (Ch = '.') OR (Ch = '?') OR (Ch = '!') 
                  THEN 
                    BEGIN
                      FlagOne := FlagOne + 1;
                      BREAK;
                    END
                END          
            END
        END
    END;
  CLOSE(Input);  
  WRITE('Введите выходной файл: ');
  READ(OutputFile);
  ASSIGN(Output, OutputFile + '.txt');
  REWRITE(Output);
  // WRITELN(ChEnd);
  // WRITELN(Sentence);
  IF ChEnd = '?'
  THEN
    BEGIN
      FOR I := 1 TO LENGTH(Sentence) // этот цикл выносит первое слово в переменную вдруг оно будет не Кто а какое либо другое 
      DO
        BEGIN
          IF Sentence[I] = ' '
          THEN
          ELSE
            IF Sentence[I] <> ' '
            THEN
              BEGIN
                J := I;
                LetBegin := LetBegin + Sentence[I];
                IF LetBegin = KeyWord
                THEN
                  BREAK
              END 
        END;
          IF LetBegin = KeyWord
          THEN
            BEGIN
              WRITE(Output, 'Конь в пальто');
              FOR I := J + 1 TO LENGTH(Sentence) - 1 
              DO
                BEGIN
                  WRITE(Output, Sentence[I])
                END;
              WRITE(Output, '!')
            END
          ELSE
            WRITE(Output, 'Спасибо за информацию');
    END
  ELSE
    WRITE(Output, 'Спасибо за информацию');
  CLOSE(Output);
  WRITELN;
  WRITELN('Ответ записан в ', OutputFile, '.txt')
END.