# Micro-Learnning-App

[![Maintainability](https://api.codeclimate.com/v1/badges/6020ea067cd700e922d4/maintainability)](https://codeclimate.com/github/andela-venogwe/Micro-Learnning-App/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/6020ea067cd700e922d4/test_coverage)](https://codeclimate.com/github/andela-venogwe/Micro-Learnning-App/test_coverage)

A Micro Learning App Built With Sinatra, BackboneJs and ActiveRecord.

## Local Development

To run and develop this app locally, follow the steps below

- Clone the repository

  - **HTTPS**: [https://github.com/andela-venogwe/Micro-Learnning-App.git](https://github.com/andela-venogwe/Micro-Learnning-App.git)

  - **SSH**: [git@github.com:andela-venogwe/Micro-Learnning-App.git](git@github.com:andela-venogwe/Micro-Learnning-App.git)

- Install Bundler

  - Run the command `gem install bundler` in your terminal.

- Install Dependencies

  - Run the command `Bundle install` in your terminal.

- Local Config File

  - rename the `.env.sample` file to `.env`

  - Add all the specified credentials to your `.env` file

- Setup The Database

  - Run the command `rake micro_learn:setup_database` in your terminal.

- Run the App

  - Launch the app by running the command `rackup` in your terminal

  - Visit the app in your web browser on `localhost:<PORT_NUMBER>`

## Testing

Run all tests by running the command `bundle exec rspec` in your terminal

## App Features

- Registration  with `firstname`, `lastname`, `email` and `password`

- Login with `email` and `password`

- View courses to learn

- Course categories

- User Permissions and Roles
  - Roles: `user`, `instructor`, `admin`

  - Permissions:

    - User Role: `["update_profile",  "delete_profile"]`

    - Instructor Role: `[
      "create_course",
      "update_course",
      "delete_course",
      "create_topic",
      "update_topic",
      "delete_topic"
    ]`

    - Admin Role: `[
      "manage_courses",
      "manage_roles",
      "manage_topics",
      "manage_users",
      "manage_users_courses",
      "manage_users_permissions"
    ]`

- Topic notification by email

- Granular control of notifications per course

- Topic notification settings

  - Interval in days

  - Time of the day to receive topic

- Create, Update,Delete Courses by `Instructor`

- Allow embeded course topic content

- Course CRUD operation restrictions to `owners` or `admins`.

- Users can apply to become instructors

- Add/edit and disable instructors by admin - `Api only`

- Add/edit and disable course categories by admin - `Api only`
