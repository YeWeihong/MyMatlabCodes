%% edge collisionality
R = 1.85;   % major radius in m
zeff = 1;
c = 1/4.25; % inverse aspect ratio

q95 = 3.83; % webscope
ne = 3.26e19;   % in m-3
te = 378.4;    % in eV
nue = 6.921e-18 * R*q95*ne*zeff * (31.3-log(sqrt(ne)/te)) / (c^(1.5) * te^2);
ii = (31.3-log(sqrt(ne)/te));