describe Travis::Config::Serialize::Env do
  subject { described_class.new(config, prefix: 'travis').apply }

  let(:config) do
    {
      foo: { bar: :baz },
      true: true,
      false: false,
      nil: nil
    }
  end

  it { is_expected.to include 'TRAVIS_FOO_BAR=baz' }
  it { is_expected.to include 'TRAVIS_TRUE=true' }
  it { is_expected.to include 'TRAVIS_FALSE=false' }
  it { is_expected.not_to include 'TRAVIS_NIL=' }
end
