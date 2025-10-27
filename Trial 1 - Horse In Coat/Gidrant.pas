PROGRAM HorseInCoat;
VAR
  FInName, FOutName, Word: STRING;
  FIn, FOut: TEXT;
  QuestionWord: BOOLEAN;
  CompleteRecord: BOOLEAN;
  I: INTEGER;
BEGIN
  // Проверка на ввод входного файла
  WRITE('Введите имя входного файла: ');
  READLN(FInName);
  IF FInName = ''
  THEN
    BEGIN 
      WRITELN('Ошибка: имя входного файла не может быть пустым.');
      EXIT
    END;
    
  // Открытие входного файла
  ASSIGN(FIn, FInName);
  {$I-} // Отключаем проверку на ошибку
  RESET(FIn);
  {$I+} // Включаем проверку на ошибку
  
  IF IoResult <> 0
  THEN 
    BEGIN 
      WRITELN('Ошибка: не удалось открыть входной файл ', FInName);
      EXIT
    END;

  // Проверка на ввод выходного файла
  WRITE('Введите имя выходного файла: ');
  READLN(FOutName);
  IF FOutName = ''
  THEN
    BEGIN 
      WRITELN('Ошибка: имя выходного файла не может быть пустым.');
      CLOSE(FIn);
      EXIT
    END;

  // Открытие выходного файла
  ASSIGN(FOut, FOutName);
  REWRITE(FOut);

  QuestionWord := FALSE;
  CompleteRecord := FALSE;
  Word := '';

  // Чтение и обработка входного файла
  WHILE NOT EOF(FIn)
  DO
    BEGIN
      READ(FIn, Word);
      
      // Проверка на слово "Кто" или его варианты
      IF (Word = 'Кто') OR (Word = 'кто') OR (Word = 'Кто?') OR (Word = 'кто?') OR (Word = 'Кто,') OR (Word = 'кто,')
      THEN
        QuestionWord := TRUE;

      // Проверка на конец предложения
      IF QuestionWord AND ((Word[Length(Word)] = '!') OR (Word[Length(Word)] = '.'))
      THEN
        QuestionWord := FALSE;
    END;

  // Обработка последнего предложения
  IF QuestionWord AND (Word[Length(Word)] = '?')
  THEN
    BEGIN
      // Перемотка файла назад до позиции слова "Кто"
      RESET(FIn);
      
      // Запись "Конь в пальто" в выходной файл
      WRITE(FOut, 'Конь в пальто');
      
      // Чтение и запись оставшейся части предложения
      WHILE NOT EOF(FIn)
      DO
        BEGIN
          READ(FIn, Word);
          CompleteRecord := TRUE;
          IF Word[Length(Word)] = '?'
          THEN
            Word[Length(Word)] := '!';
          WRITE(FOut, ' ', Word);
        END;

      // Завершение записи
      IF NOT CompleteRecord
      THEN
        WRITE(FOut, '!')
      ELSE
        WRITELN(FOut);
    END
  ELSE
    BEGIN
      // Запись "Спасибо за информацию" в выходной файл
      WRITE(FOut, 'Спасибо за информацию!');
    END;

  // Закрытие файлов
  CLOSE(FIn);
  CLOSE(FOut);

  WRITELN('Запись ответа произошла успешно');
END.
