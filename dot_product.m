% Dot product in Matlab using serial for, parfor, and builtin methods
% The builtin parallel routine will use all cores available


   % Allocate and initialize the X and Y vectors

%N=100000;
N=100000000;
ncores=8;

X=rand( N, 1 );
Y=rand( N, 1 );

zarray = zeros( [125000000,1], 'double' );  % Clear the cache

   % Time a serial dot product

Dprod=0.0;
tic  % start the timer

for i = 1:N
   Dprod = Dprod + X(i) * Y(i);
end

t_end = toc;
disp(['serial loop took ', num2str(t_end), ' seconds with Dprod = ', num2str(Dprod)]);


   % Time the internal dot prodduct which is multi-threaded

zarray = zeros( [125000000,1], 'double' );  % Clear the cache
tic  % start the timer

Dprod = dot( X, Y);

t_end = toc;
disp(['builtin dot product took ', num2str(t_end), ' seconds with Dprod = ', num2str(Dprod)]);


   % Time a single-node multi-process  parfor dot product

tic

parpool('local', ncores)    % Fire up the virtual cluster of processes

t_end = toc;
disp([num2str(t_end), ' seconds to spin up multi-process pool']);

zarray = zeros( [125000000,1], 'double' );  % Clear the cache
tic  % start the timer

Dprod=0.0;
parfor i = 1:N
   Dprod = Dprod + X(i) * Y(i);
end

t_end = toc;
disp(['multi-process parfor loop took ', num2str(t_end), ' seconds with Dprod = ', num2str(Dprod)]);


exit; % NOTE: Multi-threads not supported in older versions of Matlab


   % Time a single-node multi-thread parfor matrix multiply

delete( gcp( 'nocreate' ) );   % Destroy the local parpool

tic

parpool('threads', ncores)

t_end = toc;
disp([num2str(t_end), ' seconds to spin up multi-thread pool']);

zarray = zeros( [125000000,1], 'double' );  % Clear the cache
tic  % start the timer

Dprod = 0.0;
parfor i = 1:N
   Dprod = Dprod + X(i) * Y(i);
end

t_end = toc;
disp(['multi-threaded parfor loop took ', num2str(t_end), ' seconds with Dprod = ', num2str(Dprod)]);

exit;


