## Using Jenkins Template Folder:

Jenkins template folder is there to help you get started with Declarative Jenkins pipeline with a kubernetes agent.
To use the template folder, follow the following steps:
1. Copy `jenkins-template` folder to your repository and rename it to a more appropriate name, maybe `jenkins`.
2. Open up Jenkinsfile and change `label-name` (on line 4) to an appropraite label-name that would suit your project.
3. Navigate to `agent.yaml` file and change `container-name` (on line 8) to an appropriate value, you would be using this value under your steps to let Jenkins know on which container you would like to carry out your commands in.
4. While on `agent.yaml` file, change `image-name` (on line 9) to an image you would like to use for the particular container.
5. If you would like to alter `resources` block, feel free to do so, just make sure you do not allocate more resources than a node can sustain.
