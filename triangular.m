function y=triangular(t)
    for i=1:length(t)
        aux=mod(t(i),2*pi);
        if aux<pi
        y(i)=1-(2/pi)*aux;
        else
        y(i)=-3+(2/pi)*aux;
        end
       
    end
end