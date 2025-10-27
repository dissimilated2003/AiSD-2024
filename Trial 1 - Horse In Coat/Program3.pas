PROGRAM HorseInCoat;

TYPE
  PSentencePtr = ^TSentence;
  TSentence = RECORD
                Text: STRING;
                IsFirstWordWho: BOOLEAN;
                IsQuestion: BOOLEAN;
                Next: PSentencePtr;
              END;

VAR
  InFile, OutFile: TEXT;
  Ch: CHAR;
  InputFileName, OutputFileName, NewText: STRING;
  Head, Current, NewSentence, LastSentence: PSentencePtr;
  I: INTEGER;

BEGIN
  WRITE('Введите имя входного файла: ');
  READLN(InputFileName);

  IF InputFileName = ''
  THEN
    BEGIN 
      WRITELN('Ошибка: имя входного файла не может быть пустым.');
      EXIT
    END;

  WRITE('Введите имя выходного файла: ');
  READLN(OutputFileName);

  IF OutputFileName = ''
  THEN
    BEGIN 
      WRITELN('Ошибка: имя выходного файла не может быть пустым.');
      EXIT
    END;
    
  ASSIGN(InFile, InputFileName); 
  {$I-} // Отключаем проверку на ошибку
  RESET(InFile);
  {$I+} // Включаем проверку на ошибку

  IF IoResult <> 0
  THEN 
    BEGIN 
      WRITELN('Ошибка: не удалось открыть входной файл ', InputFileName);
      EXIT
    END;

  ASSIGN(OutFile, OutputFileName);
  REWRITE(OutFile);

  HEAD := NIL;

  WHILE NOT EOF(InFile)
  DO 
    BEGIN
      New(NewSentence);
      NewSentence^.Text := '';
      NewSentence^.IsFirstWordWho := FALSE;
      NewSentence^.IsQuestion := FALSE; 
      Current := NewSentence;
  
      REPEAT
        READ(InFile, Ch);
        Current^.Text := Current^.Text + Ch;
        IF (Ch = '.') OR (Ch = '?') OR (Ch = '!')
        THEN 
          BEGIN
            IF(Current^.Text[1] = 'К') AND (Current^.Text[2] = 'т') AND 
            (Current^.Text[3] = 'о') AND (Current^.Text[4] in [' ', ','])
            THEN
              Current^.IsFirstWordWho := TRUE;
        
            IF Ch = '?' 
            THEN
              Current^.IsQuestion := TRUE;

            // Завершение предложения
            Current^.Next := Head;
            Head := Current; 
            WRITE(Head^.Text);
            BREAK; // Завершение считывания этого предложения
          END; 
        UNTIL EOF(InFile);
    END;
  
  // Последнее предложение
  Current := Head;
  
  // Проверка последнего предложения
  IF Current^.IsQuestion AND Current^.IsFirstWordWho
  THEN 
    BEGIN
      NewText := '';
      I := 1;
      WHILE I <= Length(Current^.Text)
      DO 
        BEGIN
          IF (I <= Length(Current^.Text) - 2) AND (Current^.Text[I] = 'К') AND 
          (Current^.Text[I + 1] = 'т') AND (Current^.Text[I + 2] = 'о')
          THEN 
            BEGIN
              NewText := NewText + 'Конь в пальто';
              I := I + 3; // Пропустить "к", "т", "о"
            END 
          ELSE 
            BEGIN
              NewText := NewText + Current^.Text[I];
              I := I + 1 // Переход к следующему символу
            END
        END;
      IF Current^.Text[Length(Current^.Text)] = '?'
      THEN
        NewText := NewText + '!';
      Current^.Text := NewText;
    END 
  ELSE 
    BEGIN
      // Если не вопрос или не начинается с "кто"
      WRITE(OutFile, 'Спасибо за информацию!'); 
    END;
    
  // Запись предложений в файл  
  IF Current^.IsQuestion AND Current^.IsFirstWordWho
  THEN
    BEGIN
      Current := Head;
      WHILE Current <> NIL
      DO 
        BEGIN
          WRITE(OutFile, Current^.Text);
          Current := Current^.Next; 
          IF Current <> NIL
          THEN
            WRITE(OutFile, ' ')  
        END
    END;
    
  // Освобождение памяти
  Current := Head;
  WHILE Current <> NIL
  DO 
    BEGIN
      LastSentence := Current;
      Current := Current^.Next;
      Dispose(LastSentence);
    END;

  CLOSE(InFile);
  CLOSE(OutFile);
END.
