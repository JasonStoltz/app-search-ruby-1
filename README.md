<p align="center"><img src="https://github.com/elastic/app-search-ruby/blob/master/logo-app-search.png?raw=true" alt="Elastic App Search Logo"></p>

<p align="center"><a href="https://circleci.com/gh/elastic/app-search-ruby"><img src="https://circleci.com/gh/elastic/app-search-ruby.svg?style=svg" alt="CircleCI build"></a></p>

> A first-party Ruby client for building excellent, relevant search experiences with Elastic App Search.

## Contents

- [Getting started](#getting-started-)
- [Versioning](#versioning)
- [Usage](#usage)
- [Running Tests](#running-tests)
- [Debugging API Calls](#debugging-api-calls)
- [FAQ](#faq-)
- [Contribute](#contribute-)
- [License](#license-)

---

## Getting started 🐣

To install the gem, execute:

```bash
gem install elastic-app-search
```

Or place `gem 'elastic-app-search', '~> 7.4.0'` in your `Gemfile` and run `bundle install`.

## Versioning

This client is versioned and released alongside App Search.

To guarantee compatibility, use the most recent version of this library within the major version of the corresponding App Search implementation.

For example, for App Search `7.3`, use `7.3` of this library or above, but not `8.0`.

If you are a [SaaS](https://app.swiftype.com/as) user, simply use the most recent version of this library.

## Usage

### Setup: Configuring the client and authentication

Create a new instance of the Elastic App Search Client. This requires your `[HOST_IDENTIFIER]`, which
identifies the unique hostname of the App Search API that is associated with your App Search account.
It also requires a valid `[API_KEY]`, which authenticates requests to the API. You can use any key type with the client, however each has a different scope. For more information on keys, check out the [documentation](https://swiftype.com/documentation/app-search/credentials).

You can find your `[API_KEY]` and your `[HOST_IDENTIFIER]` within the [Credentials](https://app.swiftype.com/as/credentials) menu:

```ruby
require 'elastic-app-search'

client = Elastic::AppSearch::Client.new(:host_identifier => 'host-c5s2mj', :api_key => 'private-mu75psc5egt9ppzuycnc2mc3')
```

### Using with App Search Managed Deploys

The client can be configured to use a managed deploy by using the
`api_endpoint` parameter. Since managed deploys do not rely on a `[HOST_IDENTIFIER]`
, it can be omitted.

```ruby
require 'elastic-app-search'

client = Elastic::AppSearch::Client.new(:api_key => 'private-mu75psc5egt9ppzuycnc2mc3', :api_endpoint => 'http://localhost:3002/api/as/v1/')
```

### API Methods

This client is a thin interface to the Elastic App Search Api. Additional details for requests and responses can be
found in the [documentation](https://swiftype.com/documentation/app-search).

#### Indexing: Creating or Updating a Single Document

```ruby
engine_name = 'favorite-videos'
document = {
  :id => 'INscMGmhmX4',
  :url => 'https://www.youtube.com/watch?v=INscMGmhmX4',
  :title => 'The Original Grumpy Cat',
  :body => 'A wonderful video of a magnificent cat.'
}

client.index_document(engine_name, document)
```

#### Indexing: Creating or Replacing Documents

```ruby
engine_name = 'favorite-videos'
documents = [
  {
    :id => 'INscMGmhmX4',
    :url => 'https://www.youtube.com/watch?v=INscMGmhmX4',
    :title => 'The Original Grumpy Cat',
    :body => 'A wonderful video of a magnificent cat.'
  },
  {
    :id => 'JNDFojsd02',
    :url => 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    :title => 'Another Grumpy Cat',
    :body => 'A great video of another cool cat.'
  }
]

client.index_documents(engine_name, documents)
```

#### Indexing: Updating Documents (Partial Updates)

```ruby
engine_name = 'favorite-videos'
documents = [
  {
    :id => 'INscMGmhmX4',
    :title => 'Updated title'
  }
]

client.update_documents(engine_name, documents)
```

#### Retrieving Documents

```ruby
engine_name = 'favorite-videos'
document_ids = ['INscMGmhmX4', 'JNDFojsd02']

client.get_documents(engine_name, document_ids)
```

#### Listing Documents

```ruby
engine_name = 'favorite-videos'

client.list_documents(engine_name)
```

#### Destroying Documents

```ruby
engine_name = 'favorite-videos'
document_ids = ['INscMGmhmX4', 'JNDFojsd02']

client.destroy_documents(engine_name, document_ids)
```

#### Listing Engines

```ruby
client.list_engines
```

#### Retrieving Engines

```ruby
engine_name = 'favorite-videos'

client.get_engine(engine_name)
```

#### Creating Engines

```ruby
engine_name = 'favorite-videos'

client.create_engine(engine_name)
```

#### Destroying Engines

```ruby
engine_name = 'favorite-videos'

client.destroy_engine(engine_name)
```

#### Searching

```ruby
engine_name = 'favorite-videos'
query = 'cat'
search_fields = { :title => {} }
result_fields = { :title => { :raw => {} } }
options = { :search_fields => search_fields, :result_fields => result_fields }

client.search(engine_name, query, options)
```

#### Multi-Search

```ruby
engine_name = 'favorite-videos'

queries = [{
  :query => 'cat',
  :options => { :search_fields => { :title => {} }}
},{
  :query => 'dog',
  :options => { :search_fields => { :body => {} }}
}]

client.multi_search(engine_name, queries)
```

#### Query Suggestion

```ruby
engine_name = 'favorite-videos'

options = {
  :size => 3,
  :types => {
    :documents => {
      :fields => ['title']
    }
  }
}

client.query_suggestion(engine_name, 'cat', options)
```

#### Show Search Settings

```ruby
engine_name = 'favorite-videos'

client.show_settings(engine_name)
```

#### Update Search Settings

```ruby
engine_name = 'favorite-videos'

settings = {
  "search_fields" => {
    "id" => {
      "weight" => 1
    },
    "url" => {
      "weight" => 1
    },
    "title" => {
      "weight" => 1
    },
    "body" => {
      "weight" => 1
    },
  },
  "boosts" => {
    "title" => [
      {
        "type" => "value",
        "factor" => 9.5,
        "operation" => "multiply",
        "value" => [
          "Titanic"
        ]
      }
    ]
  }
}

client.update_settings(engine_name, settings)
```

#### Reset Search Settings

```ruby
engine_name = 'favorite-videos'

client.reset_settings(engine_name)
```

#### Create a Signed Search Key

Creating a search key that will only return the title field.

```ruby
public_search_key = 'search-xxxxxxxxxxxxxxxxxxxxxxxx'
public_search_key_name = 'search-key'
enforced_options = {
  result_fields: { title: { raw: {} } },
  filters: { world_heritage_site: 'true' }
}

signed_search_key = Elastic::AppSearch::Client.create_signed_search_key(public_search_key, public_search_key_name, enforced_options)

client = Elastic::AppSearch::Client.new(host_identifier: 'host-c5s2mj', api_key: signed_search_key)
client.search('national-parks-demo', 'everglade')
```

## Running Tests

```bash
export AS_API_KEY="[API_KEY]"
export AS_HOST_IDENTIFIER="[HOST_IDENTIFIER]"
bundle exec rspec
```

You can also run tests against a local environment by passing a `AS_API_ENDPOINT` environment variable

```bash
export AS_API_KEY="[API_KEY]"
export AS_API_ENDPOINT="http://[HOST_IDENTIFIER].api.127.0.0.1.ip.es.io:3002/api/as/v1"
bundle exec rspec
```

## Debugging API calls

If you need to debug an API call made by the client, there are a few things you could do:

1. Setting `AS_DEBUG` environment variable to `true` would enable HTTP-level debugging and you would
   see all requests generated by the client on your console.

2. You could use our API logs feature in App Search console to see your requests and responses live.

3. In your debug logs you could find a `X-Request-Id` header value. That could be used when talking
   to Elastic Customer Support to help us quickly find your API request and help you troubleshoot
   your issues.

## FAQ 🔮

### Where do I report issues with the client?

If something is not working as expected, please open an [issue](https://github.com/elastic/app-search-ruby/issues/new).

### Where can I learn more about App Search?

Your best bet is to read the [documentation](https://swiftype.com/documentation/app-search).

### Where else can I go to get help?

You can checkout the [Elastic App Search community discuss forums](https://discuss.elastic.co/c/app-search).

## Contribute 🚀

We welcome contributors to the project. Before you begin, a couple notes...

- Before opening a pull request, please create an issue to [discuss the scope of your proposal](https://github.com/elastic/app-search-ruby/issues).
- Please write simple code and concise documentation, when appropriate.

## License 📗

[Apache 2.0](https://github.com/elastic/app-search-ruby/blob/master/LICENSE.txt) © [Elastic](https://github.com/elastic)

Thank you to all the [contributors](https://github.com/elastic/app-search-ruby/graphs/contributors)!
