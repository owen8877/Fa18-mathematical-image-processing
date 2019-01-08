function A=func2mat(fun,Xtypical,varargin)
%FUNC2MAT - Obtain the matrix representing a linear function.
%
%Given a handle to a linear function f(X), where X is a numeric array
%of fixed size, the code will find the matrix A such that Y=f(X) is 
%equivalent to Y(:)=A*X(:).
%
%Input syntaxes are
%
%  A=func2mat(fun,Xtypical)
%  A=func2mat(fun,Xtypical, Parameter1,Value1,Parameter2, Value2...)
%
%where
%
% fun: a function handle to f() accepting the syntax fun(Xtypical).
%
% Xtypical: is a numerical array accepted as input by fun() and reflecting 
%           the dimension of the space the final matrix will operate on.
%
% A: The output matrix. The dimensions of A are MxN where N=numel(Xtypical) 
%    and M=numel(fun(Xtypical)).
%
%Parameter/Value options
%
%  'UseParallel': Default=false. If true, and if you have the Parallel 
%                 Computing Toolbox and if you have an open matlabpool,
%                 the code will try to use PCT functions to the best
%                 advantage.
%
%  'doSparse':  Default=true. If true, output matrix a will be type sparse. 
%               Otherwise, A will be a full, type double matrix.
%option processing
options=struct(varargin{:});
if isfield(options,'UseParallel')
   UseParallel=options.UseParallel;
else
    UseParallel=false;
end
if isfield(options,'doSparse')
   doSparse=options.doSparse;
else
   doSparse=true;
end
if issparse(Xtypical)
   
    [mm,nn]=size(Xtypical);
    Xtypical=spalloc(mm,nn,1);
    
else
    
   Xtypical(:)=0;
end
N=numel(Xtypical);
if doSparse
    I=cell(N,1);J=I;S=I;
    
        if ~UseParallel
            for j=1:N
             Xtypical(j)=1;
             T=fun(Xtypical);
             [I{j}, ~, S{j}] = find(T(:));
             J{j}=I{j};
               J{j}(:)=j; 
             Xtypical(j)=0;
            end
        else
            parfor j=1:N
             input=Xtypical;
             input(j)=1;
             T=fun(input);
             [I{j}, ~, S{j}] = find(T(:));
             J{j}=I{j};
               J{j}(:)=j;
            end   
            T=fun(Xtypical);
        end
            M=numel(T); clear T
            I=cell2mat(I);
            J=cell2mat(J);
            S=cell2mat(S);
           A=sparse(I,J,S,M,N);
else%ouput type full
    
    
       T=fun(Xtypical);
       M=numel(T);
       
       
        if ~UseParallel
            A=zeros(M,N);
            
            for j=1:N
             Xtypical(j)=1; %#ok<*SPRIX>
             T=fun(Xtypical);
             A(:,j)=T(:);
             
             Xtypical(j)=0;
            end
        else
   
             
            A=zeros(M,N); 
            parfor j=1:N
             input=Xtypical;
             input(j)=1;
             T=fun(input); %#ok<*PFBNS>
             A(:,j)=T(:);
          
             
            end
            
            
       end
        
end
