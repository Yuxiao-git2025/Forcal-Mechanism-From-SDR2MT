% =========================================================================
% Plot 3-D P-wave radiation pattern from moment tensor
%
% Inputs:
%   M can be:
%       1) 3x3 moment tensor
%       2) 3x3xN moment tensors
%       3) Nx6 array in format:
%            [M11, M22, M33, M23, M13, M12]
%
%   Coordinate convention:
%       1 = N
%       2 = E
%       3 = Z
%
%   ndiv:
%       sampling density of the sphere, default 50.
%
%   ax:
%       optional axes handle. Recommended only for single event.
%
% Output:
%   h is a structure array containing graphics handles.
%
% Main formula:
%   For ray direction gamma=[N,E,Z],
%
%       A = gamma * M * gamma'
%
%   abs(A) controls the radius of the radiation lobe
%   sign(A) controls the color
% =========================================================================
function h=MEC_PlotPRadiation(M,ndiv,ax)
if nargin<2 || isempty(ndiv)
    ndiv=30;
end
if nargin<3
    ax=[];
end
M3=MEC_PRadiationInput2Matrix(M);
Nevent=size(M3,3);
h=repmat(struct( ...
    'figure',[], ...
    'axes',[], ...
    'mesh',[], ...
    'axisN',[], ...
    'axisE',[], ...
    'axisZ',[], ...
    'labelN',[], ...
    'labelE',[], ...
    'labelZ',[]),Nevent,1);

for i=1:Nevent
    Mi=M3(:,:,i);
    Mi=(Mi+Mi.')/2;
    if isempty(ax)
        fig=figure;
        axi=gca;
    else
        if Nevent>1
            error('MEC_PlotPRadiation:badAxes', ...
                'An axes handle can only be used for a single event');
        end
        fig=ancestor(ax,'figure');
        axi=ax;
        axes(axi);
    end
    cla(axi);
    hold(axi,'on');
    [X,Y,Z,C]=MEC_PRadiationSurface(Mi,ndiv);

    h(i).figure=fig;
    h(i).axes=axi;
    h(i).mesh=mesh(axi,X,Y,Z,C);
    set(h(i).mesh,'LineWidth',0.6);
    colormap(axi,MEC_PRadiationColormap(C));
    axis(axi,'tight');
    axis(axi,'equal');
    axis(axi,'off');
    grid(axi,'off');
    view(axi,[0 -30]);
    camup(axi,[0 0 -1]); % NEZ axis setting

    h(i)=MEC_DrawPRadiationAxes(axi,X,Y,Z,h(i));
    Fun_Decorat;
    hold(axi,'off');
    if isempty(ax)
        set(fig,'Position',[400,85,650,580]);
    end
%     if ~isempty(plotFile)
%         thisFile=MEC_PRadiationFileName(plotFile,i,Nevent);
%         saveas(fig,thisFile,'png');
%     end
end

end



function M3=MEC_PRadiationInput2Matrix(M)
% Convert supported input to 3x3xN moment tensor matrix
if ~isnumeric(M) || ~isreal(M)
    error('MEC_PRadiationInput2Matrix:badInput', ...
        'Moment tensor must be real numeric.');
end
if ismatrix(M) && all(size(M)==[3 3])
    M3=M;
    M3=reshape(M3,3,3,1);
elseif ndims(M)==3 && size(M,1)==3 && size(M,2)==3
    M3=M;
elseif ismatrix(M) && size(M,2)==6
    Nevent=size(M,1);
    M3=nan(3,3,Nevent);
    M11=M(:,1);
    M22=M(:,2);
    M33=M(:,3);
    M23=M(:,4);
    M13=M(:,5);
    M12=M(:,6);
    for i=1:Nevent
        M3(:,:,i)=[M11(i),M12(i),M13(i);
                   M12(i),M22(i),M23(i);
                   M13(i),M23(i),M33(i)];
    end
else
    error('MEC_PRadiationInput2Matrix:badInput', ...
        'Input must be 3x3, 3x3xN, or Nx6.');
end
for i=1:size(M3,3)
    M3(:,:,i)=(M3(:,:,i)+M3(:,:,i).')/2;
end
end


function [X,Y,Z,C]=MEC_PRadiationSurface(M,ndiv)
% Calculate P-wave radiation surface
theta=linspace(0,pi,ndiv+1);
phi=linspace(0,2*pi,2*ndiv+1);
Ntheta=numel(theta);
Nphi=numel(phi);

X=nan(Nphi,Ntheta);
Y=nan(Nphi,Ntheta);
Z=nan(Nphi,Ntheta);
C=nan(Nphi,Ntheta);

for it=1:Ntheta
    th=theta(it);

    for ip=1:Nphi
        ph=phi(ip);

        x=cos(ph)*sin(th);
        y=sin(ph)*sin(th);
        z=cos(th);

        gamma=[x,y,z];

        amp=gamma*M*gamma.';

        C(ip,it)=sign(amp);

        radius=abs(amp);

        X(ip,it)=radius*x;
        Y(ip,it)=radius*y;
        Z(ip,it)=radius*z;
    end
end

end

function cmap=MEC_PRadiationColormap(C)
% Blue and red colormap with special handling for uniform sign patterns
blue=[0 0.2 1];
red =[0.9098    0.0627    0.4039];
if all(C(:)>=0)
    cmap=[red; red];
elseif all(C(:)<=0)
    cmap=[blue; blue];
else
    cmap=[blue; red];
end

end

function h=MEC_DrawPRadiationAxes(ax,X,Y,Z,h)
% Draw N, E, Z coordinate axes
maxX=max(abs(X(:)));
maxY=max(abs(Y(:)));
maxZ=max(abs(Z(:)));
scale=max([maxX,maxY,maxZ]);
if ~isfinite(scale) || scale==0
    scale=1;
end
L=1.4*scale;
h.axisN=plot3(ax,[0 L],[0 0],[0 0],'k-','LineWidth',1.2);
h.axisE=plot3(ax,[0 0],[0 L],[0 0],'k-','LineWidth',1.2);
h.axisZ=plot3(ax,[0 0],[0 0],[0 L],'k-','LineWidth',1.2);
h.labelN=text(ax,1.1*L,0,0,'$N$', ...
    'FontSize',18,'HorizontalAlignment','center','Interpreter','latex');
h.labelE=text(ax,0,1.1*L,0,'$E$', ...
    'FontSize',18,'HorizontalAlignment','center','Interpreter','latex');
h.labelZ=text(ax,0,0,1.1*L,'$Z$', ...
    'FontSize',18,'HorizontalAlignment','center','Interpreter','latex');

end
