const
keyWord = 'Кто';
var
  input,output: text;
  inputFile, outputFile: string;
  sentence, letBegin: string;
  flag,flagOne, i, j: integer;
  ch, chEnd: CHAR;
 //Основная программа
  begin
    writeln('Введите входной файл');
    readln(inputFile);
    assign(input, inputFile);
    reset(input);
    flag:= 0;
    while not eof(input)
    do
      begin
        read(input,ch);
        if (ch = '.') or (ch = '?') or (ch = '!') 
        then 
          begin
            flag:= flag + 1;
          chEnd:= ch;
          end;
          
      end;
    reset(input); 
    while not eof(input)
    do
      begin
        read(input,ch);
        if (ch = '.') or (ch = '?') or (ch = '!') 
        then 
          flagOne:= flagOne + 1;
          if flagOne = flag - 1
          then
            begin
              while flagOne <> flag
              do
                begin
                  if eoln(input)
                  then
                    readln(input,ch)
                    else
                    begin
                      read(input, ch);
                      sentence:= sentence + ch;
                      if (ch = '.') or (ch = '?') or (ch = '!') 
                      then 
                        begin
                          flagOne:= flagOne + 1;
                          break;
                        end;
                    end;
                  
                end;
            end;
      end;
     close(input);  
     writeln('Введите выходной файл');
     read(outputFile);
     assign(output, outputFile);
     rewrite(output);
    
      
  
    if chEnd = '?'
    then
      begin
        for i:= 1 to length(sentence) // этот цикл выносит первое слово в переменную вдруг оно будет не Кто а какое либо другое 
        do
          begin
            if sentence[i] <> ' '
            then
              begin
                j:= i;
                letBegin:= letBegin + sentence[i];
                
              end;
             if letBegin = keyWord 
             then
               if (sentence[i+1] = ' ') or (sentence[i+1] = '?') or (sentence[i+1] = ',') or (sentence[i+1] = ':')
               then
                 break 
               else
                begin
                  write(output, 'Спасибо за информацию');
                  close(output);
                  exit
                end;
           end;   
          if letBegin = keyWord
          then
            begin
              write(output, 'Конь в пальто');
              for i := j + 1 to length(sentence) - 1 do
              begin
                write(output, sentence[i])
              end;
              write(output, '!')
            end
          
      end
    else
      write(output, 'Спасибо за информацию');
     close(output); 
  end.