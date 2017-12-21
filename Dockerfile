FROM openjdk:8-windowsservercore                                                                                                
MAINTAINER peter@pouliot.net
ENV JENKINS_SWARM_VERSION 3.3                                                                                                   
ENV HOME /jenkins-slave                                                                                                         

RUN mkdir \jenkins-slave                                                                                                        
RUN powershell -Command Invoke-WebRequest $('https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/{0}/swarm-
client-{0}.jar' -f $env:JENKINS_SWARM_VERSION) -OutFile 'swarm-client.jar' -UseBasicParsing ;                                   
# Note: Install Chocolatey                                                                                                      
RUN \                                                                                                                           
    # Install Chocolatey                                                                                                        
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.
org/install.ps1'))                                                                                                              
RUN \                                                                                                                           
    # Install Choco Package                                                                                                     
    choco install openssh git wget curl docker docker-compose docker-machine rsync unzip winrar dotnet4.6.2 python3 ruby nodejs 
cygwin cyg-get sysinternals -Y ; \                                                                                              
    refreshenv ;\                                                                                                               
    cmd.exe /c "c:\programdata\chocolatey\bin\cyg-get.bat expect mail bind-utils xinit xorg-docs" ;\                            
    refreshenv ;\                                                                                                               
    cmd.exe /c "c:\tools\ruby24\bin\gem install octokit r10k hiera-eyaml" ;\                                                    
    cmd.exe /c "c:\ProgramData\chocolatey\bin\wget.exe --no-check-certificate https://bootstrap.pypa.io/get-pip.py" ;\          
    cmd.exe /c "c:\Python36\python.exe get-pip.py" ; \                                                                          
    refreshenv ;\                                                                                                               
    cmd.exe /c "c:\Python36\Scripts\pip.exe install PyGithub jenkins-job-builder jenkins-job-wrecker" ;                                                                


COPY jenkins-slave.cmd /jenkins-slave.cmd                                                                                       

VOLUME C:\\jenkins-slave                                                                                                        

ENTRYPOINT [ "cmd", "/C", "C:\\jenkins-slave.cmd" ] 
