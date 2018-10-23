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
