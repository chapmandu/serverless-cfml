# Serverless CFML Lambda Functions

Standing on the shoulders of the [fuseless.org](https://fuseless.org/) project.

It's primary differences are:

- Handles multiple serverless applications
- Uses the Serverless framework rather than SAM
- Unit tests cfml components
- Allows local/staging/production deployment configurations

## Installation (\*nix)

Either run the `./run install` script* in your terminal or install manually.

- [Java JDK](https://openjdk.org/install/)
- [Gradle](https://gradle.org/install/)
- [Serverless Framework](https://www.serverless.com/framework/docs/getting-started)

\* sudo required

- Install [Commandbox](https://www.ortussolutions.com/products/commandbox)

## Development

*./functions/greeter/Application.cfc*

`fuselessEvent()` is the entry point for invoked Lambda functions

`onRequest()` is the entry point for Lambda functions called via API gateway

### Creating a new Serverless Application

Follow the basic structure of the "greeter" application.

- Modify:
  - `./functions/yournewapp/cfml/app/Application.cfc`
  - `./functions/yournewapp/serverless.yml`
  - `./functions/yournewapp/tests/run`
  - `./functions/yournewapp/tests/*.cfc`

- Most other cfcs can be removed

### Configuration

`./functions/greeter/config` contains the custom env variables that are available to `serverless.yml`

## ./run script

`./run help` will list the commands available

## Testing

Run all tests

`cd functions/greeter`

`./run test`

Run tests separately

`./run test:serverless`

`./run test:unit`

Run the unit tests in a browser:

`cd rocketunit`

`box server start openbrowser=true --noSaveSettings`

## Deployment

You will need a "serverless" role in AWS IAM that has permission to perform all the resource creation defined in your `serverless.yml`

See https://www.serverless.com/framework/docs/providers/aws/cli-reference/deploy

## Credits

- [Pete Freitag](https://fuseless.org/)
- [Ortus Solutions](https://www.ortussolutions.com/products/commandbox)
- [Robin Hilliard](https://github.com/robinhilliard/rocketunit)
- [Ben Nadel](https://www.bennadel.com/blog/3801-pretty-printing-a-coldfusion-query-object-in-lucee-cfml-5-2-9-31.htm)

### Pull Requests Welcome

---

Thanks go to the [Flying Spaghetti Monster](https://www.spaghettimonster.org/)

> I am the Flying Spaghetti Monster. Thou shalt have no other monsters before Me (Afterwards is OK; just use protection). The only Monster who deserves capitalization is Me! Other monsters are false monsters, undeserving of capitalization.

\-- Suggestions 1:1
