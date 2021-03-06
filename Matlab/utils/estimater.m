r=read_complex_binary('/home/traviscollins/data/post.txt');
s=read_complex_binary('/home/traviscollins/data/pre.txt');

prea=s(10:110);
stem(abs(xcorr(prea,s(1:500))))
figure(2)
stem(abs(xcorr(prea,r(1:500))))


cor=abs(xcorr(r(1:500),prea));
%remove padding
cor=cor(length(r(1:500))-length(prea):end);

%find first preamble
[indexs,~]=find(cor>=max(cor));

first=indexs(1);
start=first-length(prea);
r=r(start:start+length(prea)-1)';
s=prea';

% %equalize
% m=length(r);
% n=9; f=zeros(n,1);           % initialize equalizer at 0
% f(1)=1;
% mu=.02; delta=2;             % stepsize and delay delta
% index=1;
% output=zeros(1,length(r));
% for i=n+1:m                  % iterate
%   rr=r(i:-1:i-n+1)';         % vector of received signal
%   e=s(i-delta)-rr'*f;        % calculate error
%   
%   f=f+mu*e*rr;               % update equalizer coefficients
%   output(index)=f'*rr;
%   index=index+1;
% end
% 
% yt=filter(f,1,r);            % use final filter f to test

%equalizer2
n=9;                               % length of equalizer - 1
%n=50;
delta=0;                           % use delay <=n*length(b)
p=length(r)-delta;
R=toeplitz(r(n+1:p),r(n+1:-1:1));  % build matrix R
S=s(n+1-delta:p-delta)';           % and vector S
f=inv(R'*R)*R'*S;                   % calculate equalizer f
Jmin=S'*S-S'*R*inv(R'*R)*R'*S;      % Jmin for this f and delta
y=filter(f,1,r);                   % equalizer is a filter

%Filter without filter command
output=zeros(1,length(y));
index=1;
for i=1:length(r)-n
    rr=r(i:i+length(f)-1);
    output(index)=f'*rr';
    index=index+1;
end
    

%Calculate Error
error=sum(abs(y-prea'));
error=sum(abs(output(1:end-n)-prea(1:end-n)'));
h=conv(f,[1 zeros(1,length(prea)-n-1)]);
x=conv(r,h); %Extend channel size
%remove padding
x=x(1:length(prea));
error=sum(abs(x-prea'));



disp(['Error: ',num2str(error)]);

%MRC
% equalization maximal ratio combining
result=sum(output,2);

%for i=1:length(f):length(r)-mod(length(r),length(f));  
%   yHat =[yHat  sum(conj(f).*r(i:i+length(f)-1),1)./sum(f.*conj(f),1)]; 
%end




