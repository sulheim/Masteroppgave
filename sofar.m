function sofar(howmuch)
% sofar(%complete).

  if (nargin == 0), return; end;
  howmuch=round(howmuch);
  if howmuch<0,
    howmuch = 0;
  elseif howmuch>100,
    howmuch = 100;
  end;
    
  [existFlag,figNumber]=figflag('Sofar',0);
  NewWinFlag=~existFlag;

  if NewWinFlag,
    position=get(0,'DefaultFigurePosition');
    position(3:4)=[200 30];
    figNumber=figure( ...
      'Name','Sofar', ...
      'NumberTitle','off', ...
      'MenuBar','none', ...
      'Resize','off', ...
      'Position',position);
  end;
  clf
  axes('position',[0 0 1 1]);
  sf=zeros(1,100); sf(1,1:howmuch)=ones(1,howmuch);
  image(sf+1);
  colormap(gray(2));
  if howmuch == 100, 
    h=text(42,1,'DONE!');
  else
    h=text(42,1,[int2str(howmuch),' %']);
  end;
  set(h,'Color',[1 0 0]);
  axis('off'); drawnow;
