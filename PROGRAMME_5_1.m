%      PROGRAMME 5.1: Add noise to the image

%        function b=imnoise(varargin)  %IMNOISE Add noise to image.
%        J = IMNOISE(I,TYPE,...) Add noise of a given TYPE to the intensity image
%        I.TYPE is a string that can have one of these values:
%           'gaussian'           Gaussian white noise with constant    mean and variance
%           'lacalvar'   Zero-mean Gaussian white noise    with an intensity-dependent variance
%           'salt & pepper'   "On and Off" pixels
%        Depending on TYPE,you can specify additional paramaeters to IMNOISE,All
%        numerical parameters are normalized; they correspond to operations with
%        images with intensities ranging from 0 to 1.
%        J=IMNOISE(I,'gaussian',M,V)adds Gaussian white noise of mean M and
%        variance V to the image I.When unspecified,M and V default to 0 and
%        0.01 respectively.
%        J= imnoise(I,'localvar,'V) adds zero-mean, Gaussian white noise of
%        local variance, V, to the image I.  V is an array of the same size as I.
%        J=imnoise(I,'localvar',IMAGE_INTENSITY,VAR) adds zero-mean,Gaussian
%        noise to an image,I,where the local variance of the noise is a
%        function of the image intensity values in I.    IMAGE_INTENSITY and VAR
%        are vectors of the same size, and PLOT(IMAGE_INTENSITY,VAR) plots the
%        functional relationship between noise variance and image intensity.
%        IMAGE_INTENSITY must contain normalized intensity values ranging from 0 to 1.
%        J = IMNOISE(I,'poisson')generates Poisson noise from the data instead
%        of adding artificial noise to the data.   If is double precision,
%        then input pixel values are interpreted as maeans of Poisson
%        distributions scaled up by 1e12.   For example, if an input pixel has
%        the value 5.5e-12, then the corresponding output pixel will be
%        generated from a Poisson distribution with mean of 5.5 and then scaled
%        back down by 1e12.   If I is single precision, the scale factor used is
%        1e6.  If I is uint8 or uint16, then input pixel values are used
%        directly without scaling.  For example, If a pixel in a uint8 input
%        has a value 10, then the corresponding output pixel will be
%        generated from a Poisson distribution with mean 10.
%        J = IMNOISE(I,'salt & pepper',D) adds"salt and pepper" noise to the
%        image I, where D is the noise density.   This affects approximately
%        D*numel(I) pixels. The default for D is 0,05.
%        J = IMNOISE(I,'speckle',V) adds multiplicative noise to the image I, 
%        using the equation J=I+n*I, where n is uniformly distributed random 
%        noise with mean and variance V.The default for V is 0.04
%        The mean and variance parameters for'gaussian', 'localvar',and
%        'speekle'noise types are always specified as if for a double, adds noise
%        according to the specified type and parameters, and then converts the
%        noisy image back to the same class as input.
%        Class Support
%        For most noise types,I can be uint8,uint16,double,int16,or
%        single. For Poisson noise,int16 is not allowed.The output
%        image J has the same class as I. If I has more than two dimensions
%        it is treated as a multidimensional intensity image and not as an RGB image.
%        Example
%            I=imread('eight,tif):
%            J=imnoise(I,'salt&pepper',0.02):
%            figure,imshow(I0,figure,imshow(J)
%        See also RAND,RANDN.
%And then invoke the function PROGRAMM5-1:
I=imread('Test2.jpg');
I1=imnoise(I,'gaussian',0,0.05); %0.05 là ?? l?ch chu?nt
I2 = imnoise(I,'salt & pepper',0.02);
subplot(1,3,1),imshow(I);
title('original image');
subplot(1,3,2),imshow(I1); % add Gaussian noise
title('gaussian image');
subplot(1,3,3),imshow(I2); % Salt and pepper noise
title('salt & pepper');