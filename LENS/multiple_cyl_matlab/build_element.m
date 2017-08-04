function e=build_element(x,y,r,e);
    persistent fide fid0 fid1 nel rc;
    e=e+1;
    e
    if size(r,1) < 2; r=r'; end;
    if e==1; rc=zeros(4,300); end;
    if e>0;  rc(:,e)=r; end;


    if length(x)==4; x(5)=x(1); y(5)=y(1); end;
    plot(x,y,'r.-','linewidth',1)
    axis equal
%   [e r']
%   pause

    if e==0;  %%% PRINT CURVE SIDE INFO & CLOSE FILES

      fprintf(fide,'%9d %s %9d %s\n',nel,' 2 ',nel,' elements');

%     rc(:,1:20)'
%     nel
%     pause

      ncurve=0;
      for e=1:nel; for k=1:4;
        if abs(rc(k,e)) > 0; ncurve=ncurve+1, end;
      end;end;
      fprintf(fid1,'%s\n',' CURVED SIDE DATA');
      fprintf(fid1,'%9d %s\n',ncurve,' curve sides follow');

      sc='C'; z=0.;
      if nel < 1000;
       for e=1:nel; for k=1:4; if abs(rc(k,e)) > 0;
        fprintf(fid1,'%3d%3d%14.6e%14.6e%14.6e%14.6e%14.6e %s\n',...
                k,e,rc(k,e),z,z,z,z,sc); end; end;end;
      else
       for e=1:nel; for k=1:4; if abs(rc(k,e)) > 0;
        fprintf(fid1,'%2d%6d%14.6e%14.6e%14.6e%14.6e%14.6e %s\n',...
                k,e,rc(k,e),z,z,z,z,sc); end; end;end;
      end;

      fclose(fid0); fclose(fid1); fclose(fide);

    else    %%% PRINT ELEMENT VERTEX INFO

      if e==1; fide=fopen('rea.nel','w'); 
               fid0=fopen('rea.xy','w'); fid1=fopen('rea.cs','w'); end;
      s1= '            ELEMENT';
      s2= '[    1a]    GROUP     0';
      fprintf(fid0,'%s%5d %s\n',s1,e,s2);
      fprintf(fid0,'%16.8e %16.8e %16.8e %16.8e\n',x(1),x(2),x(3),x(4));
      fprintf(fid0,'%16.8e %16.8e %16.8e %16.8e\n',y(1),y(2),y(3),y(4));

%%    Set CURVE sides if radii are the same for a given element
      x(5)=x(1); y(5)=y(1); rr=x.*x+y.*y;
      for k=1:4
         rbar=.5*(rr(k)+rr(k+1)); rdif=abs(rr(k)-rr(k+1))/rbar;
         if rc(k,e)==0 && rdif < 1000*eps; rbar=sqrt(rbar);
            xm=sum(x(1:4))/4; ym=sum(y(1:4))/4; rm=sqrt(xm*xm+ym*ym);
            if rbar > rm; rc(k,e)=rbar; end;
            if rbar < rm; rc(k,e)=-rbar; end;
         end;
      end;
    end;
    nel = e;
