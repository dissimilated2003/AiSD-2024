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
  WRITE('������� ��� �������� �����: ');
  READLN(InputFileName);

  IF InputFileName = ''
  THEN
    BEGIN 
      WRITELN('������: ��� �������� ����� �� ����� ���� ������.');
      EXIT
    END;

  WRITE('������� ��� ��������� �����: ');
  READLN(OutputFileName);

  IF OutputFileName = ''
  THEN
    BEGIN 
      WRITELN('������: ��� ��������� ����� �� ����� ���� ������.');
      EXIT
    END;
    
  ASSIGN(InFile, InputFileName); 
  {$I-} // ��������� �������� �� ������
  RESET(InFile);
  {$I+} // �������� �������� �� ������

  IF IoResult <> 0
  THEN 
    BEGIN 
      WRITELN('������: �� ������� ������� ������� ���� ', InputFileName);
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

        // �������� �� ������ ����� "���"
        IF (Length(Current^.Text) >= 4) AND
           (Current^.Text[1] = '�') AND (Current^.Text[2] = '�') AND 
           (Current^.Text[3] = '�') AND (Current^.Text[4] in [' ', ','])
        THEN
          Current^.IsFirstWordWho := TRUE;
        
        IF (Ch = '.') OR (Ch = '?') OR (Ch = '!')
        THEN 
          BEGIN
            IF Ch = '?' 
            THEN
              Current^.IsQuestion := TRUE;

            // ���������� �����������
            Current^.Next := Head;
            Head := Current; 
            WRITE(Head^.Text);
            BREAK; // ���������� ���������� ����� �����������
          END; 
      UNTIL EOF(InFile);
    END;
  
  // ��������� �����������
  Current := Head;
  
  // �������� ���������� �����������
  IF Current^.IsQuestion //AND Current^.IsFirstWordWho
  THEN 
    BEGIN
      NewText := '';
      I := 1;
      WHILE I <= Length(Current^.Text)
      DO 
        BEGIN
          IF (I <= Length(Current^.Text) - 2) AND (Current^.Text[I] = '�') AND 
          (Current^.Text[I + 1] = '�') AND (Current^.Text[I + 2] = '�')
          THEN 
            BEGIN
              NewText := NewText + '���� � ������';
              I := I + 3; // ���������� "�", "�", "�"
            END 
          ELSE 
            BEGIN
              NewText := NewText + Current^.Text[I];
              I := I + 1 // ������� � ���������� �������
            END
        END;
      IF Current^.Text[Length(Current^.Text)] = '?'
      THEN
        NewText := NewText + '!';
      Current^.Text := NewText;
    END 
  ELSE 
    BEGIN
      // ���� �� ������ ��� �� ���������� � "���"
      WRITE(OutFile, '������� �� ����������!'); 
    END;
    
  // ������ ����������� � ����  
  IF Current^.IsQuestion //AND Current^.IsFirstWordWho
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
    
  // ������������ ������
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
