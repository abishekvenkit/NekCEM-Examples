
e=0; ncirc=0; format compact; rc=[0 0 0 0];
for k=1:9;

  k0=2*k-1; k1=k0+1; k2=k1+1;
  X=zeros(k2,3); Y=X;
  rk = 1.5*k-1.0; r0=rk+0.08; r1=rk+0.22; r2=rk+0.42;
  t0=0:(k0-1);  t0=(pi/4)*t0'/(k0-1);
  t1=0:(k1-1);  t1=(pi/4)*t1'/(k1-1);
  t2=0:(k2-1);  t2=(pi/4)*t2'/(k2-1);
  
  X(1:k0,1)=r0.*cos(t0); X(1:k1,2)=r1.*cos(t1); X(1:k2,3)=r2.*cos(t2);
  Y(1:k0,1)=r0.*sin(t0); Y(1:k1,2)=r1.*sin(t1); Y(1:k2,3)=r2.*sin(t2);
  plot(X(1:k0,1),Y(1:k0,1),'r.--','linewidth',.3); hold on
  plot(X(1:k1,2),Y(1:k1,2),'g.--','linewidth',.3)
  plot(X(1:k2,3),Y(1:k2,3),'b.--','linewidth',.3); axis equal

  x=zeros(1,5);y=x;
  for j=1:k-1;
    x(1)=X(j,1);x(2)=X(j,2);x(3)=X(j+1,2);x(4)=X(j+1,1); x(5)=x(1);
    y(1)=Y(j,1);y(2)=Y(j,2);y(3)=Y(j+1,2);y(4)=Y(j+1,1); y(5)=y(1);
%   plot(x,y,'ro-'); axis equal; hold on;
    if k>1; e=build_element(x,y,rc,e); end;
  end;

  for j=k:k0-1;
    x(1)=X(j,1);x(2)=X(j+1,2);x(3)=X(j+2,2);x(4)=X(j+1,1); x(5)=x(1);
    y(1)=Y(j,1);y(2)=Y(j+1,2);y(3)=Y(j+2,2);y(4)=Y(j+1,1); y(5)=y(1);
%   plot(x,y,'go-'); axis equal; hold on; end;
    if k>1; e=build_element(x,y,rc,e); end;
  end;

  for j=1:k-1;
    x(1)=X(j,2);x(2)=X(j,3);x(3)=X(j+1,3);x(4)=X(j+1,2); x(5)=x(1);
    y(1)=Y(j,2);y(2)=Y(j,3);y(3)=Y(j+1,3);y(4)=Y(j+1,2); y(5)=y(1);
%   plot(x,y,'bo-'); axis equal; hold on; end;
    if k>1; e=build_element(x,y,rc,e); end;
  end;

  for j=k+1:k1-1;
    x(1)=X(j,2);x(2)=X(j+1,3);x(3)=X(j+2,3);x(4)=X(j+1,2); x(5)=x(1);
    y(1)=Y(j,2);y(2)=Y(j+1,3);y(3)=Y(j+2,3);y(4)=Y(j+1,2); y(5)=y(1);
%   plot(x,y,'ko-'); axis equal; hold on; 
    if k>1; e=build_element(x,y,rc,e); end;
  end;

  xbar = (X(k,1)+X(k,2)+X(k+1,2)+X(k,3)+X(k+1,3)+X(k+2,3))/6;
  ybar = (Y(k,1)+Y(k,2)+Y(k+1,2)+Y(k,3)+Y(k+1,3)+Y(k+2,3))/6;
  x(1)=X(k,1);x(2)=X(k,2);x(3)=xbar;x(4)=X(k+1,2);x(5)=x(1);
  y(1)=Y(k,1);y(2)=Y(k,2);y(3)=ybar;y(4)=Y(k+1,2);y(5)=y(1);
  plot(x,y,'ro-','linewidth',2); axis equal; hold on;
  if k>1; e=build_element(x,y,rc,e); end;

  x(1)=X(k,2);x(2)=X(k,3);x(3)=X(k+1,3);x(4)=xbar;x(5)=x(1);
  y(1)=Y(k,2);y(2)=Y(k,3);y(3)=Y(k+1,3);y(4)=ybar;y(5)=y(1);
  plot(x,y,'go-','linewidth',2); axis equal; hold on;
  if k>1; e=build_element(x,y,rc,e); end;

  x(1)=xbar;x(2)=X(k+1,3);x(3)=X(k+2,3);x(4)=X(k+1,2);x(5)=x(1);
  y(1)=ybar;y(2)=Y(k+1,3);y(3)=Y(k+2,3);y(4)=Y(k+1,2);y(5)=y(1);
  plot(x,y,'bo-','linewidth',2); axis equal; hold on; 
  if k>1; e=build_element(x,y,rc,e); end;

  if k>1; [e,ncirc]=build_semi_circles(X0,Y0,X,Y,e,ncirc); end;


  X0=X; Y0=Y;

end;
e=build_element(x,y,rc,-1);
[e,ncirc]=build_semi_circles(X0,Y0,X,Y,e,-1);


