require 'rails_helper'

RSpec.describe 'Grouping', type: :request do
  describe 'GET /grouping' do
    context 'パラメータが正しい場合' do
      it 'ステータス200を返すこと' do
        get '/grouping' + '?AAB'
        expect(response).to have_http_status(200)
      end
    end

    context 'AAABBBCCCの場合(アルファベットが複数連続する)' do
      it 'A3B3C3を返すこと' do
        get '/grouping' + '?AAABBBCCC'
        json = JSON.parse(response.body)
        expect(json['data']).to eq 'A3B3C3'
      end
    end

    context 'ABABABABABABABABABAの場合(アルファベットが交互にある)' do
      it 'ABABABABABABABABABAを返すこと' do
        get '/grouping' + '?ABABABABABABABABABA'
        json = JSON.parse(response.body)
        expect(json['data']).to eq 'ABABABABABABABABABA'
      end
    end

    context 'AAAAABBBBBCCCCCDDDDDEEEEEAAABBCABABACCCCCCCの場合(連続した同じアルファベットが跨いである)' do
      it 'A5B5C5D5E5A3B2CABABAC7を返すこと' do
        get '/grouping' + '?AAAAABBBBBCCCCCDDDDDEEEEEAAABBCABABACCCCCCC'
        json = JSON.parse(response.body)
        expect(json['data']).to eq 'A5B5C5D5E5A3B2CABABAC7'
      end
    end

    context 'AaBBbbCCCcccの場合(アルファベットが大文字小文字含んでいる)' do
      it 'AaB2b2C3c3を返すこと' do
        get '/grouping' + '?AaBBbbCCCccc'
        json = JSON.parse(response.body)
        expect(json['data']).to eq 'AaB2b2C3c3'
      end
    end

    context 'パラメータが正しくない場合' do
      it 'ステータス400を返すこと' do
        get '/grouping'
        expect(response).to have_http_status(400)
      end
    end
  end
end
