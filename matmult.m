% Matrix multiplication in Matlab using serial for, parfor, and builtin methods
% The builtin parallel routine will use all cores available


   % Allocate and initialize the A and B matrices

N=100;
ncores=4;

A=rand( N, N );
B=rand( N, N );


   % Time a serial matrix multiply

C=zeros( N, N, 'double' );
tic  % start the timer

for i = 1:N
   for j = 1:N
      for k = 1:N
         C(i,j) = C(i,j) + A(i,k)*B(k,j);
      end
   end
end

t_end = toc;
%disp(C);
disp(['serial loop took ', num2str(t_end), ' seconds']);


   % Time the internal matrix multiply which is multi-threaded

C=zeros( N, N, 'double' );
tic  % start the timer

C = A * B;

t_end = toc;
%disp(C);
disp(['builtin matmult took ', num2str(t_end), ' seconds']);


   % Time a single-node multi-process  parfor matrix multiply

tic

parpool('local', ncores)    % Fire up the virtual cluster of processes

t_end = toc;
disp([num2str(t_end), ' seconds to spin up multi-process pool']);

C=zeros( N, N, 'double' );
tic  % start the timer

parfor i = 1:N
   for j = 1:N
      for k = 1:N
         C(i,j) = C(i,j) + A(i,k)*B(k,j);
      end
   end
end

t_end = toc;
%disp(C);
disp(['multi-process parfor loop took ', num2str(t_end), ' seconds']);


exit; % NOTE: Multi-threads not supported in older versions of Matlab


   % Time a single-node multi-thread parfor matrix multiply

delete( gcp( 'nocreate' ) );   % Destroy the local parpool

tic

parpool('threads', ncores)

t_end = toc;
disp([num2str(t_end), ' seconds to spin up multi-thread pool']);

C=zeros( N, N, 'double' );
tic  % start the timer

parfor i = 1:N
   for j = 1:N
      for k = 1:N
         C(i,j) = C(i,j) + A(i,k)*B(k,j);
      end
   end
end

t_end = toc;
%disp(C);
disp(['multi-threaded parfor loop took ', num2str(t_end), ' seconds']);

exit;

