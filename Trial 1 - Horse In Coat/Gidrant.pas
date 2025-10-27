PROGRAM HorseInCoat;
VAR
  FInName, FOutName, Word: STRING;
  FIn, FOut: TEXT;
  QuestionWord: BOOLEAN;
  CompleteRecord: BOOLEAN;
  I: INTEGER;
BEGIN
  // �������� �� ���� �������� �����
  WRITE('������� ��� �������� �����: ');
  READLN(FInName);
  IF FInName = ''
  THEN
    BEGIN 
      WRITELN('������: ��� �������� ����� �� ����� ���� ������.');
      EXIT
    END;
    
  // �������� �������� �����
  ASSIGN(FIn, FInName);
  {$I-} // ��������� �������� �� ������
  RESET(FIn);
  {$I+} // �������� �������� �� ������
  
  IF IoResult <> 0
  THEN 
    BEGIN 
      WRITELN('������: �� ������� ������� ������� ���� ', FInName);
      EXIT
    END;

  // �������� �� ���� ��������� �����
  WRITE('������� ��� ��������� �����: ');
  READLN(FOutName);
  IF FOutName = ''
  THEN
    BEGIN 
      WRITELN('������: ��� ��������� ����� �� ����� ���� ������.');
      CLOSE(FIn);
      EXIT
    END;

  // �������� ��������� �����
  ASSIGN(FOut, FOutName);
  REWRITE(FOut);

  QuestionWord := FALSE;
  CompleteRecord := FALSE;
  Word := '';

  // ������ � ��������� �������� �����
  WHILE NOT EOF(FIn)
  DO
    BEGIN
      READ(FIn, Word);
      
      // �������� �� ����� "���" ��� ��� ��������
      IF (Word = '���') OR (Word = '���') OR (Word = '���?') OR (Word = '���?') OR (Word = '���,') OR (Word = '���,')
      THEN
        QuestionWord := TRUE;

      // �������� �� ����� �����������
      IF QuestionWord AND ((Word[Length(Word)] = '!') OR (Word[Length(Word)] = '.'))
      THEN
        QuestionWord := FALSE;
    END;

  // ��������� ���������� �����������
  IF QuestionWord AND (Word[Length(Word)] = '?')
  THEN
    BEGIN
      // ��������� ����� ����� �� ������� ����� "���"
      RESET(FIn);
      
      // ������ "���� � ������" � �������� ����
      WRITE(FOut, '���� � ������');
      
      // ������ � ������ ���������� ����� �����������
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

      // ���������� ������
      IF NOT CompleteRecord
      THEN
        WRITE(FOut, '!')
      ELSE
        WRITELN(FOut);
    END
  ELSE
    BEGIN
      // ������ "������� �� ����������" � �������� ����
      WRITE(FOut, '������� �� ����������!');
    END;

  // �������� ������
  CLOSE(FIn);
  CLOSE(FOut);

  WRITELN('������ ������ ��������� �������');
END.
