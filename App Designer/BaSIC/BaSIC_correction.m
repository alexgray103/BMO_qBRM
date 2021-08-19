function BaSIC_correction(images_dir, plot_val)
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%% images_dir = location of folder with all images that need to be corrected
   %%%%%% plot_val = logical value to say whether to plot darkfield and flatfield
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
  
  
    % read in Image set and do correction and overwrite all images
    files =dir([images_dir '*.tif']);
    for i = 1:length(files)  
        IF(:,:,i) = imread([images_dir files(i).name]); % original image
    end
    % estimate flatfield and darkfield
    % For fluorescence images, darkfield estimation is often necessary (set
    % 'darkfield' to be true)
    [flatfield,darkfield] = BaSiC(IF,'darkfield','true');  

    % plot estimated shading files
    % note here darkfield does not only include the contribution of microscope
    % offset, but also scattering light that entering to the light path, which
    % adds to every image tile
    if plot_val
        figure; subplot(121); imagesc(flatfield);colorbar; title('Estimated flatfield');
        subplot(122); imagesc(darkfield);colorbar;title('Estimated darkfield');
    end 
   
    % image correction
    IF_corr = zeros(size(IF));
    for i = 1:length(files)
        IF_corr(:,:,i) = (double(IF(:,:,i))-darkfield)./flatfield;
    end

    % save images for stitching
    file_location = [images_dir '\corrected']; 
    for i = 1:length(files)
        imwrite(uint8(IF_corr(:,:,i)),sprintf('%simg_%03d',file_location, i));
    end
end 
