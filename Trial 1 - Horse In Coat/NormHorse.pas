PROGRAM NormHorse(INPUT, OUTPUT);
CONST
  N = 200;  
  M = 100;  
  FInName = 'MessageIn.txt';  
  FOutName = 'MessageOut.txt';
VAR  
  Sentence: ARRAY[1 .. N] OF STRING;  
  Sent, LetterBegin: STRING;
  FIn, FOut: TEXT;    
  I, J: INTEGER;
  Ch: CHAR;
//нахуя тебе эта функция смысл ее выносить
FUNCTION IsQuestion(S: STRING): BOOLEAN;
BEGIN
  IF LENGTH(S) < 255
  then
   IF S[LENGTH(S)] = '?'
  THEN
    IsQuestion := TRUE
  ELSE
    IsQuestion := FALSE
END;
// она не правильная
FUNCTION ReplaceWho(S: STRING): STRING;
VAR  
  ResultStr: STRING;  
  Word: STRING;  
  I: INTEGER;
BEGIN  
  ResultStr := '';  
  Word := '';
  FOR I := 1 TO LENGTH(S) 
  DO
    BEGIN  
      IF (S[I] <> ' ') AND (S[I] <> '?') AND (S[I] <> '!') AND (S[I] <> '.') 
      THEN
        Word := Word + S[I]        
      ELSE
        BEGIN      
          IF (Word = 'Кто') OR (Word = 'кто') OR (Word = 'КТО') 
          THEN
            //нахуй ты прибовляешь нельзя сделать ResultStr := 'Конь в пальто' у тебя между словами быть ';'
            ResultStr := ResultStr + 'Конь в пальто'
          ELSE
            ResultStr := ResultStr + Word;
          ResultStr := ResultStr + S[I]; 
          Word := '';
        END;  
    END;
    //нахуй здесь повторное условие
  IF (Word = 'Кто') OR (Word = 'кто') OR (Word = 'КТО') THEN    
    ResultStr := ResultStr + 'Конь в пальто'
  ELSE    
    ResultStr := ResultStr + Word;
  ReplaceWho := ResultStr; 
END;

BEGIN // пошла лошадиная сила 
  I := 1;  
  ASSIGN(FIn, FInName);  
  RESET(FIn);  
  ASSIGN(FOut, FOutName);
  REWRITE(FOut);
  WHILE NOT EOF(FIn) and (I< 32700)
  DO
    BEGIN    
      READ(FIn, Ch);
      Sentence[I] := Sentence[I] + Ch;
      IF (Ch = '?') and (Ch = '!') and (Ch = '.')
      then
        Sent := Sentence[I];
        I := I + 1;  
    END;
  
    
    
      
      IF Sent[length(Sent)] = '?' 
      THEN
        BEGIN
          Sent[LENGTH(Sent)] := '!';
          LetterBegin := ReplaceWho(Sent); 
          Sentence[I-1] := LetterBegin; 
        END
        //у тебя че только одно условие которое ведет спасибо за информацию цикл for выше крч нахуй все перепиши представь что ты робот и се выполняешь определенные программы
      ELSE
        BEGIN
          WRITELN(FOut, 'Спасибо за информацию!');
          exit;
        END;
    FOR J := 1 TO I - 1 // ты понимаешь что здесь ты рассматриваешь каждое предложение нахуй тебе это надо рассмотри последнее поэтому у тебя else не выполняется так как до него и не доходит
  DO
    BEGIN
      WRITELN(FOut, Sentence[J]) 
    END;    
        
        
  CLOSE(FIn);
  CLOSE(FOut);
END.
