%--------------------------------------------------------------------------
% INSTALL_Submission
% INSTALL file template
%--------------------------------------------------------------------------
% 
%--------------------------------------------------------------------------
% Primary Contributor: Daniel R. Herber, Graduate Student, University of 
% Illinois at Urbana-Champaign
% Link: https://github.com/danielrherber/mfx-submission-install-utilities
%--------------------------------------------------------------------------
function INSTALL_Tool

    % add contents to path
    AddSubmissionContents(mfilename)

    % download required web zips
    RequiredWebZips
    
    % toolbox version checks
    MinimumVersionChecks

    % add contents to path (files have been downloaded)
    AddSubmissionContents(mfilename)

    % open examples
    OpenThisFile('Main') 
    
    
    % close this file
    CloseThisFile(mfilename) % this will close this file

end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function RequiredWebZips
    disp('--- Obtaining required web zips')

    % initialize index
    ind = 0;

    % initialize structure
    zips = struct('url','','folder','','test','');

    % zip: Figure workflow to create improved figures
    ind = ind + 1; % increment
    zips(ind).url = 'https://github.com/danielrherber/matlab-figure-workflow/archive/refs/heads/main.zip';
    zips(ind).folder = 'matlab-figure-workflow';
    zips(ind).test = 'commonFigureProperties';

    % zip: DTQP
    ind = ind + 1; % increment
    zips(ind).url = 'https://github.com/danielrherber/dt-qp-project/archive/refs/heads/master.zip';
    zips(ind).folder = 'MFX 8773';
    zips(ind).test = 'dt-qp-project';

    % obtain full function path
    full_fun_path = which(mfilename('fullpath'));
    outputdir = fullfile(fileparts(full_fun_path),'include');

    % download and unzip
    DownloadWebZips(zips,outputdir)

    % Install DTQP
    INSTALL_DTQP
    CloseThisFile('BrysonHo166')

    disp(' ')
end
%--------------------------------------------------------------------------
function MinimumVersionChecks
disp('--- Checking toolbox versions')

% initialize index
ind = 0;

% initialize structure
test = struct('toolbox','','version','');

% test 1: MATLAB
ind = ind + 1; % increment
test(ind).toolbox = 'matlab';
test(ind).name = 'MATLAB';
test(ind).version = 'R2023b'; % any?
test(ind).required = true;

% test 2: Optimization Toolbox
ind = ind + 1; % increment
test(ind).toolbox = 'optim';
test(ind).name = 'Optimization Toolbox';
test(ind).version = '0'; % any?
test(ind).required = false;

% test 3: Parallel Computing Toolbox
ind = ind + 1; % increment
test(ind).toolbox = 'curveFit';
test(ind).name = 'Curve Fitting Toolbox';
test(ind).version = '0'; % any?
test(ind).required = false;


    % download and unzip
    VersionChecks(test)

    disp(' ')
end
%--------------------------------------------------------------------------
function AddSubmissionContents(name)
    disp('--- Adding submission contents to path')
    disp(' ')

    % current file
    fullfuncdir = which(name);

    % current folder 
    submissiondir = fullfile(fileparts(fullfuncdir));

    % add folders and subfolders to path
    addpath(genpath(submissiondir)) 
end
%--------------------------------------------------------------------------
function RunThisFile(name)
	disp(['--- Running ', name])

	try
	    % run the file
	    run(name);
	catch % error
	    disp(['Could not run ', name])
	end

	disp(' ')
end
%--------------------------------------------------------------------------
function CloseThisFile(name)
    disp(['--- Closing ', name])
    disp(' ')

    % get editor information
    h = matlab.desktop.editor.getAll;

    % go through all open files in the editor
    for k = 1:numel(h)
        % check if this is the file
        if ~isempty(strfind(h(k).Filename,name))
            % close this file
            h(k).close
        end
    end
end
%--------------------------------------------------------------------------
function OpenThisFile(name)
    disp(['--- Opening ', name])

    try
        % open the file
        open(name);
    catch % error
        disp(['Could not open ', name])
    end

    disp(' ')
end
%--------------------------------------------------------------------------
function DownloadWebFiles(files,outputdir)

    % store the current directory
    olddir = pwd;
    
    % create a folder for outputdir
    if ~exist(outputdir, 'dir')
        mkdir(outputdir); % create the folder
    else
        addpath(genpath(outputdir)); % add folders and subfolders to path
    end
    
    % change to the output directory
    cd(outputdir)
    
    % go through each file
    for k = 1:length(files)
        
        % get data
        url = files(k).url;
        folder = files(k).folder;
        [~,nameurl,exturl] = fileparts(url);
        name = [nameurl,exturl];
        
        % first check if the test file is in the path
        if exist(name,'file') == 0
            
            try
                % download file
                outfilename = websave(name,url);
            
                % create a folder utilizing name as the foldername name
                if ~exist(fullfile(outputdir,folder), 'dir')
                    mkdir(fullfile(outputdir,folder));
                end

                % move the file
                movefile(outfilename,fullfile(outputdir,folder))

                % output to the command window
                disp(['Downloaded ',folder,'/',name])

            catch % failed to download
                % output to the command window
                disp(['Failed to download ',folder,'/',name])
                
                % remove the html file
                delete([name,'.html'])
            end
            
        else
            % output to the command window
            disp(['Already available ',name])
        end
    end
    
    % change back to the original directory
    cd(olddir)
end
%--------------------------------------------------------------------------
function DownloadWebZips(zips,outputdir)

    % store the current directory
    olddir = pwd;
    
    % create a folder for outputdir
    if ~exist(outputdir, 'dir')
        mkdir(outputdir); % create the folder
    else
        addpath(genpath(outputdir)); % add folders and subfolders to path
    end
    
    % change to the output directory
    cd(outputdir)

    % go through each zip
    for k = 1:length(zips)

        % get data
        url = zips(k).url;
        folder = zips(k).folder;
        test = zips(k).test;

        % first check if the test file is in the path
        if exist(test,'file') == 0

            try
                % download zip file
                zipname = websave(folder,url);

                % save location
                outputdirname = fullfile(outputdir,folder);

                % create a folder utilizing name as the foldername name
                if ~exist(outputdirname, 'dir')
                    mkdir(outputdirname);
                end

                % unzip the zip
                unzip(zipname,outputdirname);

                % delete the zip file
                delete([folder,'.zip'])

                % output to the command window
                disp(['Downloaded and unzipped ',folder])
            
            catch % failed to download
                % output to the command window
                disp(['Failed to download ',folder])
                
                % remove the html file
                delete([folder,'.html'])
                
            end
            
        else
            % output to the command window
            disp(['Already available ',folder])
        end
    end
    
    % change back to the original directory
    cd(olddir)
end
%--------------------------------------------------------------------------
function VersionChecks(test)
    
    % initialize counter
    counter = 0;

    % go through each file
    for k = 1:length(test)       
        try
            if verLessThan(test(k).toolbox,test(k).version) % failed
                % output to the command window
                disp(['Failed: ',test(k).toolbox,' -v', test(k).version])

            else % passed
                % output to the command window
                disp(['Passed: ',test(k).toolbox,' -v', test(k).version])
                counter = counter + 1;
                
            end
            
        catch % failed to check the toolbox
            % output to the command window
            disp(['Failed to check toolbox: ', test(k).toolbox])
            
        end
        
    end
    
    % check if all tests were passed
    if counter == length(test) % successful
        disp('All version checks passed')
    else % failure
        warning('Not all version checks were successful')
    end
    
end