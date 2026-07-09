% =========================================================================
% Plot CLVD-ISO diamond diagram
% Usage:
%   plot_diamond(clvd, iso)
%   plot_diamond(clvd, iso, ax)
%   h = plot_diamond(...)
%
% Inputs:
%   clvd : scalar, vector, or matrix of normalized CLVD fractions
%   iso  : scalar, vector, or matrix of normalized ISO fractions
%          The function plots 100*clvd and 100*iso.
%
% Optional input:
%   ax   : target axes handle
%
% Output:
%   h    : structure containing graphics handles
%
% Notes:
%   The center represents pure DC source.
%   The horizontal axis represents CLVD percentage.
%   The vertical axis represents ISO percentage.
%   Valid normalized source-type points usually satisfy:
%       abs(clvd) + abs(iso) <= 1
% =========================================================================
function h=MEC_PlotDiamond(clvd,iso,ax)
if nargin < 2
    error('plot_diamond:badInput', 'Both clvd and iso are required.');
end
if nargin < 3 || isempty(ax)
    figure;
    ax=gca;
else
    axes(ax);
end
if ~isnumeric(clvd) || ~isnumeric(iso)
    error('plot_diamond:badInput', 'clvd and iso must be numeric.');
end
clvd=clvd(:);
iso=iso(:);
if numel(clvd) ~= numel(iso)
    error('plot_diamond:badInput', ...
        'clvd and iso must have the same number of elements.');
end
bad=isnan(clvd) | isnan(iso);
if any(bad)
    warning('plot_diamond:nanInput', ...
        'NaN values were found and will not be plotted.');
end
clvd_plot=clvd(~bad);
iso_plot=iso(~bad);
out=abs(clvd_plot) + abs(iso_plot) > 1 + 1e-10;
if any(out)
    warning('plot_diamond:outsideDiamond', ...
        '%d point(s) are outside the theoretical diamond region.', ...
        sum(out));
end
hold(ax, 'on');
axis(ax, 'equal');
axis(ax, 'off');
xlim(ax, [-115 115]);
ylim(ax, [-115 115]);
% Diamond boundary in percentage coordinates
dx = [-100 0 100 0 -100];
dy = [0 -100 0 100 0];
% Draw blue diamond background
NLev=10;
% cols=(slanCM('Blues',NLev));
cols=(slanCM('greens',NLev));
% cols=MEC_whiteBlueMap(NLev);

for k=1:NLev
    scale=(NLev - k + 1) / NLev;
    h.background(k)=fill(ax, ...
        scale * dx, ...
        scale * dy, ...
        cols(k,:), ...
        'EdgeColor', 'none');
end
% Draw main axes
h.axis_clvd=plot(ax, [-100 100], [0 0], 'color',[ 0.4667    0.6745    0.1882], 'LineWidth', 0.7);
h.axis_iso=plot(ax, [0 0], [-100 100],  'color',[ 0.4667    0.6745    0.1882], 'LineWidth', 0.7);

% Draw diamond boundary
h.boundary=plot(ax, dx, dy, 'color',[0 0 0], 'LineWidth', 1.5);

% Plot CLVD-ISO points
h.points=plot(ax,100 * clvd_plot, 100 * iso_plot,'MarkerFaceColor', [1 1 1] ...
    , 'MarkerSize', 10,'marker','o','LineStyle','none','MarkerEdgeColor','k', ...
    'LineWidth',1.0);

% Optional labels
% h.label_clvd=text(ax, 107, 0, 'CLVD', ...
%     'FontSize', 20, ...
%     'HorizontalAlignment', 'left', ...
%     'VerticalAlignment', 'middle');
% h.label_iso=text(ax, 0, 110, 'ISO', ...
%     'FontSize', 20, ...
%     'HorizontalAlignment', 'center', ...
%     'VerticalAlignment', 'bottom');
% h.label_dc=text(ax, 0, 0, 'DC', ...
%     'FontSize', 20, ...
%     'Color', [0.15 0.15 0.15], ...
%     'HorizontalAlignment', 'center', ...
%     'VerticalAlignment', 'bottom');

% Add corner labels for interpretation.
h.label_pos_iso=text(ax, 0, 101, '+ISO', ...
    'FontSize', 22, ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'bottom','FontName','Times New Roman');
h.label_neg_iso=text(ax, 0, -101, '-ISO', ...
    'FontSize', 22, ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'top','FontName','Times New Roman');
h.label_pos_clvd=text(ax, 101, 0, '+CLVD', ...
    'FontSize', 22, ...
    'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'bottom','FontName','Times New Roman');
h.label_neg_clvd=text(ax, -101, 0, '-CLVD', ...
    'FontSize', 22, ...
    'HorizontalAlignment', 'right', ...
    'VerticalAlignment', 'bottom','FontName','Times New Roman');
Fun_Decorat;
hold(ax, 'off');

end


function cmap=MEC_whiteBlueMap(n)
%WHITEBLUEMAP White-to-deep-blue colormap.
%
%   cmap = whiteBlueMap(n) returns an n-by-3 RGB colormap.
%
%   The colormap starts from white and gradually changes to deep blue,
%   suitable for scalar fields normalized from 0 to 1.
if nargin < 1 || isempty(n)
    n = 256;
end
if n <= 0 || n ~= round(n)
    error('Input n must be a positive integer.');
end
% Anchor colors sampled from white to deep blue.
% Each row is [R G B], values are in [0, 1].
anchor = [
    1.00  1.00  1.00   % white
    0.88  0.92  1.00   % very light blue
    0.70  0.78  0.96   % light blue-purple
    0.48  0.60  0.90   % medium blue
    0.25  0.40  0.82   % blue
    0.05  0.18  0.65   % deep blue
    ];
xAnchor = linspace(0, 1, size(anchor, 1));
xQuery  = linspace(0, 1, n);
cmap = interp1(xAnchor, anchor, xQuery, 'pchip');
% Avoid numerical overshoot from pchip interpolation.
cmap = max(min(cmap, 1), 0);
end
