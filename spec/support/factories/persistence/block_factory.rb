FactoryBot.define do
  factory :persistence_block, class: 'Persistence::Block' do
    id_hash { 'BFB830C371E95F8484C620A7AC321B34FB44919FD4CFE3AAA1F99ED4652B5AAA' }
    height { '2668620' }
    timestamp { '2020-07-19 12:21:37.698402' }
    precommitters do
      %w[AC2D56057CD84765E6FBE318979093E8E44AA18F 000AA5ABF590A815EBCBDAE070AFF50BE571EB8B]
    end
    validator_set { { 'AC2D56057CD84765E6FBE318979093E8E44AA18F' => 247481 } }
    transactions { ['4407c0f7f87d9b36ae19f853543cf7de50fe1f1f3104486d3d17ba226bdc5dae'] }
  end
end

FactoryBot.define do
  factory :persistence_block_2, parent: :persistence_block do
    id_hash { '199FE45509EE7BC19B7B842BAC9EC9EF28738F170D8081355778CC927263D556' }
    height { '2668618' }
    precommitters do
      %w[000AA5ABF590A815EBCBDAE070AFF50BE571EB8B 000AA5ABF590A815EBCBDAE070AFF50BE571EB8B]
    end
    validator_set { { '000AA5ABF590A815EBCBDAE070AFF50BE571EB8B' => 247481 } }
  end
end

FactoryBot.define do
  factory :persistence_block_3, parent: :persistence_block do
    id_hash { '199FE45509EE7BC19B7B842BAC9EC9EF28738F170D8081355778CC927263DFD6' }
    height { '2668612' }
    precommitters do
      %w[AC2D56057CD84765E6FBE318979093E8E44AA18F 000AA5ABF590A815EBCBDAE070AFF50BE571EB8B]
    end
  end
end
