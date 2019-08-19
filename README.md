# Performance::Compare

This gem can be used to compare various implementations of the same algorithm using a single-threaded Ruby process, multi-threaded process, or multi-process pool of workers. 

Concurrency here is achieved via the gem [parallel](https://github.com/grosser/parallel) which supports both thread and process pools.

## Provided Example

In the provided example (see the `lib/algorithms` folder) we provide two implementations of the `sha1sum` algorithm: 

 1. Using Ruby's `Digest::SHA1.digest` implementation
 2. By shelling out to use the `sha1sum` binary supplied with GNU Core Utils.
 

## Installation

```bash
git clone https://github.com/kigster/performance-compare
cd performance-compare
gem install bundler
bundle
```  

## Usage

You run this tool via `exe/compare N1, N2, ... ` command line syntax. Each number corresponds to the total number of iterations for each algorithm. This is done so that algorithms that are vastly different in speed can still be effectively compared.


```bash
❯ exe/compare 10000 1000
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                                  │
│ Number of CPU Cores:                 16                                                          │
│ Method under the test:               sha1sum                                                     │
│ Number of iterations per algorithm:  [10000, 1000]                                               │
│ List of algorithms to compare:       ["Algorithms::Sha1Sum::Ruby", "Algorithms::Sha1Sum::Fork"]  │
│                                                                                                  │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
                             user     system      total        real
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│Testing Implementation: Algorithms::Sha1Sum::Ruby, 10000 iterations                               │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
sha1sum |    threads |  1  0.062405   0.001820   0.064225 (  0.065957)
sha1sum |    threads | 16  0.067567   0.003203   0.070770 (  0.068327)
sha1sum |  processes |  1  0.077446   0.039013   0.282787 (  0.251656)
sha1sum |  processes | 16  0.140628   0.157827   0.765949 (  0.216212)
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│Testing Implementation: Algorithms::Sha1Sum::Fork, 1000 iterations                                │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
sha1sum |    threads |  1  0.292745   1.256383  12.996616 ( 16.418338)
sha1sum |    threads | 16  0.351036   1.789147  22.926779 (  3.586996)
sha1sum |  processes |  1  0.031150   0.014962  12.794822 ( 15.831681)
sha1sum |  processes | 16  0.036771   0.030601  18.085052 (  7.244181)
```

### Intepreting Results

The above results show 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kigster/performance-compare.
