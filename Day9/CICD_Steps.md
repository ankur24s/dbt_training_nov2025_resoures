CICD Steps:

    PART1 - Setting Environment Variables:
        1- Setting environment variable "Edit envrironment variable for your account"
        2 - Create a new variable DBT_TARGET = DEV/UAT/PROD
        3 - Run this command in terminal:
                echo %DBT_TARGET%
                it should return DEV/UAT/PROD
        4 - You can temporarily change the variable with following command:
                set DBT_TARGET=UAT
                check with  echo %DBT_TARGET%
        5 - Now we will use env_var() macro of DBT to look for the value of DBT_TARGET variable set in environment.
               {{env_var('DBT_TARGET')}}. I can give this value for target field in my dbt profile.yml as following:
               target: "{{env_var('DBT_TARGET')}}"
               
    PART2 - Setting Branches
        1 - If you never created branches, you’re probably on the default branch — usually named main. You can confirm by running in VS Code terminal:
            git branch
        2 - Create your UAT and BUILD branches:
                git checkout build (Switch my working directory to the branch called dev)
                git checkout -b build (“Create a new branch named dev from my current branch (e.g., main), and switch to it.”)
                git checkout -b uat
                git push origin uat


            So when you switch branches, you can also switch targets:

            git checkout build
            set DBT_TARGET=DEV
            dbt run

            Then:
            git checkout uat
            set DBT_TARGET=UAT
            dbt run

            And finally:
            git checkout main
            set DBT_TARGET=PROD
            dbt run

            Each branch builds models in its own database environment.