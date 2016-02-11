# Reindeer Core

## Ideas:

admin:
    lime survey:
        create form

    group template:
        picks surveys that can be used
        pick users allowed to use template
        give title
        enabled / disabled
coach:
    group:
        pick surveys from template list to create
        pick any users to assign a survey
        alter title, description
        enable / disable
        order surveys

    survey:
        alter description
        create user_assignments for users in user_list

    user_assignment:
        make and respond to comments

student:
    user_assignment:
        listed by group
        make and respond to comments



## BUGS:
    - Count from index table is different than inside of filter
    - Style in Legacy system is messed up

## Roadmap:

    - Word Cloud
    - Performance review

    - Admin Configuration
        -Editable yaml config from within application
        - Site configuration things
            - Administrator Email address
            - LimeSurvey URL
            - Logo
            - Logo Image

    - Dashboard
        - Ajax polling for new widgets
        - Dont re-pull everything on POST

    - Versioned datasets
        - When updating via reindeer-etl in the web interface have an option to automatically version the dataset


