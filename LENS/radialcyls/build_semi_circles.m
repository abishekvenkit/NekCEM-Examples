
function [e,ncirc]=build_semi_circles(X0,Y0,X,Y,e,ncirc);

persistent fidc;
if ncirc==-1; 
  fclose(fidc); 
else;
  if ncirc==0; fidc=fopen('rea.xyc','w'); end;

  k2=size(X0,1); k1=k2-1;
  x=zeros(4,1);y=x;

  for k=1:2:k1; 

    e0=e;
    x(1)=X0(k,3);x(2)=X(k,1);x(3)=X(k+1,1);x(4)=X0(k+1,3);
    y(1)=Y0(k,3);y(2)=Y(k,1);y(3)=Y(k+1,1);y(4)=Y0(k+1,3);
    e=single_semi_circle(x,y,e);

   % Write out element numbers and corresponding circle coord
    ncirc=ncirc+1; xm=.5*(x(1)+x(2));  ym=.5*(y(1)+y(2)); 
    for ei=e0+1:e
      fprintf(fidc,'%9d %9d  %14.6e %14.6e\n',ei,ncirc,xm,ym);
    end; plot(xm,ym,'ko','linewidth',9), %pause


    e0=e;
    x(1)=X(k+2,1);x(2)=X0(k+2,3);x(3)=X0(k+1,3);x(4)=X(k+1,1);
    y(1)=Y(k+2,1);y(2)=Y0(k+2,3);y(3)=Y0(k+1,3);y(4)=Y(k+1,1);
    e=single_semi_circle(x,y,e);

   % Write out element numbers and corresponding circle coord
    ncirc=ncirc+1; xm=.5*(x(1)+x(2));  ym=.5*(y(1)+y(2)); 
    for ei=e0+1:e
      fprintf(fidc,'%9d %9d  %14.6e %14.6e\n',ei,ncirc,xm,ym);
    end; plot(xm,ym,'ko','linewidth',9), %pause

  end;

end;

function e=single_semi_circle(x,y,e);

  xc=[   0.000000      0.3800000      0.2856712       0.000000 ...
        0.2856712      0.3800000      0.5000000      0.3535534 ...
         0.000000      0.2856712      0.3535535       0.000000 ];
  yc=[   0.000000       0.000000      0.2856712      0.3800000 ...
        0.2856712       0.000000       0.000000      0.3535534 ...
        0.3800000      0.2856712      0.3535535      0.5000000 ];
  rc=[ 0 0 0 0  0 0 .5 0  0 0 .5 0 ]; rc=[rc rc]; rc=reshape(rc,4,6);


  theta = pi/2; 
  s=sin(theta); c=cos(theta); R=[ c -s ; s c ];

  X= [ xc; yc ]; X2=R*X; X=[X X2];

  n=size(x,2); if n==1; x=x';y=y'; end;

   x=[ x ; y ];

   xc = .5*(x(:,1)+x(:,2)); % Circle center;

   vc = x(:,2)-x(:,1);      % Vector through circle center

   theta = atan2(vc(2),vc(1));
   s=sin(theta); c=cos(theta); R=[ c -s ; s c ];

   X=R*X;

   Xc=X(1,:)+xc(1);
   Yc=X(2,:)+xc(2);
   Xc=[Xc ; Yc];

   k=1;
   for el=1:6; l=k+3;
       e=build_element(Xc(1,k:l),Xc(2,k:l),rc(:,el),e); k=k+4;
   end;


%  These are the points from the perimeter of the circle:
   Xoc=zeros(2,5);
   Xoc(:,1)=Xc(:,7); Xoc(:,2)=Xc(:,8); Xoc(:,3)=Xc(:,12);
   Xoc(:,4)=Xc(:,20); Xoc(:,5)=Xc(:,24);
   plot(Xoc(1,:),Xoc(2,:),'k.-','linewidth',3);% %pause;


   xm=(x(:,3)+x(:,4))/2; % Midpoint of side 3 of incoming box
   Xo=zeros(2,16);       % Coordinates of outer layer of elements
   Xo(:,1)=Xoc(:,1); Xo(:,2)=x(:,2); Xo(:,3)=x(:,3); Xo(:,4)=Xoc(:,2);    % Sewing
   Xo(:,5)=Xoc(:,2); Xo(:,6)=x(:,3); Xo(:,7)=xm; Xo(:,8)=Xoc(:,3);        % machine
   Xo(:,9)=Xoc(:,3); Xo(:,10)=xm; Xo(:,11)=x(:,4); Xo(:,12)=Xoc(:,4);     % pattern
   Xo(:,13)=Xoc(:,4); Xo(:,14)=x(:,4); Xo(:,15)=x(:,1); Xo(:,16)=Xoc(:,5);

   ro=zeros(4,4); ro(4,1)=-.5; ro(4,2)=-.5; ro(4,3)=-.5; ro(4,4)=-.5;

   k=1;
   for el=1:4; l=k+3; el
       e=build_element(Xo(1,k:l),Xo(2,k:l),ro(:,el),e); k=k+4;
%      drawnow; %pause
   end;
