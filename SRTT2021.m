%SRTT - Jisung Yuk Nov 16 2021

% Experimental parameters
clear all;
rand('state', sum(100*clock));
Screen('Preference', 'SkipSyncTests', 1);

ErrorDelay=0.5; interTrialInterval=.5; nTrialsPerBlock=60; nBlocks = 12;

Group = "RRsR";

% 1. RRsR
% 2. RRrR
% 3. LLsL
% 4. LLrL
% 5. RLsR
% 6. RLrR
% 7. LRsL
% 8. LRrL

% sequence of 12 digits %
sequence = [1 3 4 2 2 4 3 2 4 1 3 1];


KbName('UnifyKeyNames');
Key1=KbName('v'); Key2=KbName('c');
Key3=KbName('x'); Key4=KbName('z');
Key5=KbName('m'); Key6=KbName(',<');
Key7=KbName('.>'); Key8=KbName('/?');

spaceKey = KbName('space'); escKey = KbName('ESCAPE');
corrkey = [25, 6, 27, 29, 16, 54, 55, 56];
gray = [127 127 127]; white = [255 255 255]; black = [0 0 0];
bgcolor = white; textcolor = black;

%Sound Feedback 
BeepFreq = [800 1300 2000]; BeepDur = [.1 .1 .1];
Beep1 = MakeBeep(BeepFreq(1), BeepDur(1));
Beep2 = MakeBeep(BeepFreq(2), BeepDur(2));
Beep3 = MakeBeep(BeepFreq(3), BeepDur(3));
Beep4 = [Beep1 Beep2 Beep3]; 

%Login prompt and open file for writing data out 

prompt = {'Outputfile', 'Subject''s number:', 'age', 'gender', 'group'};
defaults = {'SRRT', '1', '18', 'F', ''};
answer = inputdlg(prompt,'SRTT', 2, defaults);
[output, subid, subage, gender, group] = deal(answer{:});
outputname = [output gender subid group subage '.xls'];

if exist(outputname)==2 %check to avoid overiding an existing file
    filedproblem = input('That file already exists. Appen a .x (1), overwrite (2), or break (3/default)?');
    if isempty(fileproblem) || fileproblem==3
        return;
    elseif fileproblem==1
        outputname = [outputname '.x'];
    end
end

outfile = fopen(outputname, 'w'); %open a file for writing data out
fprintf(outfile, 'subid\t subage\t gender\t group\t Hand\t blockNumber\t trialNumber\t stimulus\t ReactionTime\t \n');

% Screen parameters
[mainwin, screenrect] = Screen(0,'OpenWindow');
Screen('FillRect', mainwin, bgcolor);
center = [screenrect(3)/2 screenrect(4)/2];
Screen(mainwin, 'Flip'); 

% Experimental instructions, wait for a spacebar response to start
Screen('Fillrect', mainwin, bgcolor);
Screen('TextSize', mainwin, 24);
Screen('DrawText', mainwin, ('Serial Reaction Time Task (SRTT)'), center(1)-350, center(2)-170,textcolor);
Screen('DrawText', mainwin, ('Instructions:'), center(1)-350, center(2)-100,textcolor);
Screen('DrawText', mainwin, ('Press the indicated key with assigned hand  (e.g  _ _ _ *    LH: V RH: / )'), center(1)-350, center(2)-60,textcolor);
Screen('DrawText', mainwin, ('Left Hand keys: Z X C V  Right Hand keys: M , . /'), center(1)-350, center(2)-20,textcolor);
Screen('DrawText', mainwin, ('Press "space bar" to start the experiment.'), center(1)-350, center(2)+80,textcolor);
Screen('Flip', mainwin);

keyIsDown=0;
while 1
    [keyIsDown, secs, keyCode] = KbCheck;
    if keyIsDown
        if keyCode(spaceKey)
            break ;
        elseif keyCode(escKey)
            ShowCursor;
            fclose(outfile);
            Screen('CloseAll');
            return;
        end
    end
end
WaitSecs(0.3);


% Block loop

for a = 1:nBlocks
    Screen('FillRect', mainwin, bgcolor);
    Screen('TextSize', mainwin, 34);
    
    if a == 1
        
        if Group == "LLsL" || Group == "LLrL" || Group == "LRsL" || Group == "LRrL"
            blocktype = 'Left Hand';
            Screen('DrawText', mainwin, ('Left hand response: Use left hand to press keys'), center(1)-400, center(2), textcolor);
        else
            blocktype = 'Right Hand';
            Screen('DrawText', mainwin, ('Right hand response: Use right hand to press keys'), center(1)-400, center(2), textcolor); 
        end
        
    elseif a == 2
        
        if Group == "RRsR" || Group == "RRrR" || Group == "LRsL" || Group == "LRrL"
            blocktype = 'Right Hand';
            Screen('DrawText', mainwin, ('Right hand response: Use right hand to press keys'), center(1)-400 , center(2) , textcolor);
        else
            blocktype = 'Left Hand';
            Screen('DrawText', mainwin, ('Left hand response: Use left hand to press keys'), center(1)-400 , center(2) , textcolor);
        end
        
    elseif a == nBlocks
        
        if Group == "LLsL" || Group == "LLrL" || Group == "LRsL" || Group == "LRrL"
            blocktype = 'Left Hand';
            Screen('DrawText', mainwin, ('Left hand response: Use left hand to press keys'), center(1)-400, center(2), textcolor);
        else
            blocktype = 'Right Hand';
            Screen('DrawText', mainwin, ('Right hand response: Use right hand to press keys'), center(1)-400, center(2), textcolor); 
        end
        
    end
    
    Screen('DrawText', mainwin, ('Click to start'), center(1)-100 , center(2)+70, textcolor);
    Screen('Flip', mainwin);
    GetClicks;
    WaitSecs(1);
    

    if Group == "RRrR" || Group == "LLrL" || Group == "LRrL" || Group == "LRrL"
       Rsequence = Shuffle(sequence);
       
    else
        
       if a == 1 || a == nBlocks
          Rsequence = Shuffle(sequence); % randomize trial order for basleine and testing block
       else
          Ssequence = sequence; % Keep the sequence 
       end
       
    end
    
    
% trial loop

for i = 0:nTrialsPerBlock-1
    Screen('FillRect', mainwin, bgcolor);
        
    if Group == "RRrR" || Group == "LLrL" || Group == "LRrL" || Group == "LRrL"
       answer = Rsequence(mod(i,12)+1);
       
    else
        
        if a == 1 || a == nBlocks
        answer = Rsequence(mod(i,12)+1); 
        else
        answer = Ssequence(mod(i,12)+1); 
        end
       
    end
        
        % present stimulus
         if answer == 1
            Screen('DrawText', mainwin, ('*'), center(1)+60, center(2), textcolor);
            Screen('DrawText', mainwin, ('_'), center(1)+20, center(2), textcolor);
            Screen('DrawText', mainwin, ('_'), center(1)-20, center(2), textcolor);
            Screen('DrawText', mainwin, ('_'), center(1)-60, center(2), textcolor);
         elseif answer == 2
            Screen('DrawText', mainwin, ('_'), center(1)+60, center(2), textcolor);
            Screen('DrawText', mainwin, ('*'), center(1)+20, center(2), textcolor);
            Screen('DrawText', mainwin, ('_'), center(1)-20, center(2), textcolor);
            Screen('DrawText', mainwin, ('_'), center(1)-60, center(2), textcolor);
         elseif answer == 3
            Screen('DrawText', mainwin, ('_'), center(1)+60, center(2), textcolor);
            Screen('DrawText', mainwin, ('_'), center(1)+20, center(2), textcolor);
            Screen('DrawText', mainwin, ('*'), center(1)-20, center(2), textcolor);
            Screen('DrawText', mainwin, ('_'), center(1)-60, center(2), textcolor);
         elseif answer == 4
            Screen('DrawText', mainwin, ('_'), center(1)+60, center(2), textcolor);
            Screen('DrawText', mainwin, ('_'), center(1)+20, center(2), textcolor);
            Screen('DrawText', mainwin, ('_'), center(1)-20, center(2), textcolor);
            Screen('DrawText', mainwin, ('*'), center(1)-60, center(2), textcolor);
         end
            
        Screen('Flip', mainwin); % must flip for the stimulus to show up on the mainwin
                
        % now record response 
        timeStart = GetSecs; keyIsDown=0; correct=0; rt=0;
        
        if answer == 1
            while 1
                [keyIsDown, secs, keyCode] = KbCheck;
                FlushEvents('KeyDown');
                if keyIsDown
                    nKeys = sum(keyCode);
                    if nKeys==1
                        if keyCode(Key1) || keyCode(Key8)
                            rt = 1000.*(GetSecs-timeStart);
                            keypressed=find(keyCode);
                            Screen('Flip', mainwin);
                            break;
                        elseif keyCode(escKey)
                            ShowCursor; fclose(outfile); Screen('CloseAll'); return
                        end
                        keyIsDown=0; keyCode=0;
                    end
                end
            end
            if (keypressed==corrkey(1)) || (keypressed==corrkey(8))
                correct=1;Snd('Play', Beep4);
            end
            
        elseif answer == 2
            while 1
                [keyIsDown, secs, keyCode] = KbCheck;
                FlushEvents('KeyDown');
                if keyIsDown
                    nKeys = sum(keyCode);
                    if nKeys==1
                        if keyCode(Key2) || keyCode(Key7)
                            rt = 1000.*(GetSecs-timeStart);
                            keypressed=find(keyCode);
                            Screen('Flip', mainwin);
                            break;
                        elseif keyCode(escKey)
                            ShowCursor; fclose(outfile); Screen('CloseAll'); return
                        end
                        keyIsDown=0; keyCode=0;
                    end
                end
            end
            if (keypressed==corrkey(2)) ||  (keypressed==corrkey(7))
                correct=1;Snd('Play', Beep4);
            end
        elseif answer == 3
            while 1
                [keyIsDown, secs, keyCode] = KbCheck;
                FlushEvents('KeyDown');
                if keyIsDown
                    nKeys = sum(keyCode);
                    if nKeys==1
                        if keyCode(Key3) || keyCode(Key6)
                            rt = 1000.*(GetSecs-timeStart);
                            keypressed=find(keyCode);
                            Screen('Flip', mainwin);
                            break;
                        elseif keyCode(escKey)
                            ShowCursor; fclose(outfile); Screen('CloseAll'); return
                        end
                        keyIsDown=0; keyCode=0;
                    end
                end
            end 
            if (keypressed==corrkey(3)) || (keypressed==corrkey(6))
                correct=1;Snd('Play', Beep4);
            end
        elseif answer == 4
            while 1
                [keyIsDown, secs, keyCode] = KbCheck;
                FlushEvents('KeyDown');
                if keyIsDown
                    nKeys = sum(keyCode);
                    if nKeys==1
                        if keyCode(Key4) || keyCode(Key5)
                            rt = 1000.*(GetSecs-timeStart);
                            keypressed=find(keyCode);
                            Screen('Flip', mainwin);
                            break;
                        elseif keyCode(escKey)
                            ShowCursor; fclose(outfile); Screen('CloseAll'); return
                        end
                        keyIsDown=0; keyCode=0;
                    end
                end
            end
            if (keypressed==corrkey(4)) || (keypressed==corrkey(5))
                correct=1;Snd('Play', Beep4);
            end
        end
        
        Screen('FillRect', mainwin, bgcolor); Screen('Flip', mainwin);
        % write data out
        fprintf(outfile, '%s\t %s\t %s\t %s\t %s\t %d\t %d\t %d\t %6.2f\t \n', subid, ...,
            subage, gender, group, blocktype, a, i+1, answer, rt);
        WaitSecs(interTrialInterval);
    end
end    

        
% %        

Screen('CloseAll');
fclose(outfile);
fprintf('\n\n\n\n\nFINISHED this part! PLEASE GET THE EXPERIMENTER... \n\n');
    

