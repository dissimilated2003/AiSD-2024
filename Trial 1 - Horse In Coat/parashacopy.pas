PROGRAM HorseInCoat;
VAR
  Sent, SentCopy, Line, FInName, FOutName: STRING;
  DelimSents, DelimWords: SET OF CHAR;
  FIn, FOut: TEXT;
  I: INTEGER;
  QFlag, WhoFlag, LastFlag: BOOLEAN;
BEGIN
  // проверка на ввод входного файла
  WRITE('Введите имя входного файла: ');
  READLN(FInName);
  IF FInName = ''
  THEN
    BEGIN 
      WRITELN('Ошибка: имя входного файла не может быть пустым.');
      EXIT
    END;
    
  // проверка на ввод выходного файла
  WRITE('Введите имя выходного файла: ');
  READLN(FOutName);
  IF FOutName = ''
  THEN
    BEGIN 
      WRITELN('Ошибка: имя выходного файла не может быть пустым.');
      EXIT
    END;
    
  ASSIGN(FIn, FInName + '.txt');
  
  // тут какая-то дичь на гну паскале надо запускать я хз что это
  {$I-} // Отключаем проверку на ошибку
  RESET(FIn);
  {$I+} // Включаем проверку на ошибку
  IF IoResult <> 0
  THEN 
    BEGIN 
      WRITELN('Ошибка: не удалось открыть входной файл ', FInName);
      EXIT
    END;

  I := 1;
  Sent := '';
  Count := 0;
  DelimSents := ['.', '!', '?'];
  DelimWords := [',', ':', ' '];
  ASSIGN(FOut, FOutName + '.txt');
  REWRITE(FOut);
  WHILE NOT EOF(FIn)
  DO
    BEGIN //_________________________________________________проверка на вопрос, последнее ли
      READLN(FIn, Line);
      FOR I := 1 TO LENGTH(Line)
      DO
        BEGIN //---------------------------------------------цикл FOR итерации на строку
          IF Line[I] IN DelimSents //___________ВОПРОС ЛИ_____________
          THEN 
            BEGIN // это . ! или ?
              IF Line[I] = '?'
              THEN 
                QFlag := TRUE // встретили ? - это вопрос, QFlag = TRUE
              ELSE
                IF (Line[I] = '.') OR (Line[I] = '!')
                THEN
                  QFlag := FALSE; // встретили . или ! - это не вопрос
            END
          ELSE
            BEGIN
              SentCopy := Sent; //переношу прочитанное в буфер
              Sent := ''; //обнуляю сканер
              Sent := Sent + Line[I] //читаем дальше
            END; //_____________________ВОПРОС ЛИ_____________________
          
          IF QFlag //__________________ЕСЛИ ЭТО ВОПРОС________________
{-THEN-}  THEN
            IF (Sent[I] = 'К') AND (Sent[I + 1] = 'т') AND 
            (Sent[I + 2] = 'о') AND (Sent[I + 3] IN DelimWords)
            THEN
              BEGIN
                WhoFlag := TRUE;
                
                IF QFlag AND WhoFlag //_________если вопрос, нач с кто_____
                THEN
                  BEGIN // заносим строку в буфер, обнуляем сканер, идем дальше
                    SentCopy := Sent;
                    Sent := '';
                    Sent := Sent + Line[I]
                  END
                ELSE
                  BEGIN // если не вопр "Кто", обнуляем буфер и сканер, идем дальше
                    SentCopy := '';
                    Sent := '';
                    Sent := Sent + Line[I]
                  END;
                  
                IF (Line[I] = ' ') OR (EOF(FIn)) //последнее ли это 
                THEN
                  LastFlag := TRUE
                ELSE
                  LastFlag := FALSE;
                
                IF NOT LastFlag // если не последнее - читаем дальше
                THEN
                  Sent := '';
                  Sent := Sent + Line[I];
                
              END
            ELSE
              WhoFlag := FALSE
            
{-ELSE-}  ELSE // это не вопрос (то есть . или !), обнуляем парашу
            BEGIN
              SentCopy := '';
              Sent := '';
              Sent := Sent + Line[I]
            END        
        END //-----------------------------------------------конец FOR
    END; //__________________________________________________конец WHILE NOT EOF
    
  IF QFlag AND WhoFlag AND LastFlag // вывод в выходной файл
  THEN
    BEGIN
      WRITE(FOut, 'Конь в пальто');
      FOR I := 4 TO LENGTH(Sent) - 1
      DO
        WRITE(FOut, Sent[I]);
      WRITE('!')
    END
  ELSE
    WRITE(FOut, 'Спасибо за информацию');
  
  CLOSE(FIn); // закрывает файлы
  CLOSE(FOut)
END.