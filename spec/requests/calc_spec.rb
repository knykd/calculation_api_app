require 'rails_helper'

RSpec.describe 'Calc', type: :request do
  describe 'GET /calc' do
    context 'パラメータが正しい場合' do
      it 'ステータス200を返すこと' do
        get '/calc' + '?3+5'
        expect(response).to have_http_status(200)
      end
    end

    context '5*(8+2)の場合(式に括弧が含まれている)' do
      it '50を返すこと' do
        get '/calc' + '?5*(8+2)'
        json = JSON.parse(response.body)
        expect(json['data']).to eq 50
      end
    end

    context '((3+5)*(2*9))+(83+2)の場合(式に括弧が複数含まれている)' do
      it '229を返すこと' do
        get '/calc' + '?((3+5)*(2*9))+(83+2)'
        json = JSON.parse(response.body)
        expect(json['data']).to eq 229
      end
    end

    context '2+5の場合(足し算)' do
      it '7を返すこと' do
        get '/calc' + '?2+5'
        json = JSON.parse(response.body)
        expect(json['data']).to eq 7
      end
    end

    context '3-5の場合(引き算)' do
      it '-2を返すこと' do
        get '/calc' + '?3-5'
        json = JSON.parse(response.body)
        expect(json['data']).to eq -2
      end
    end

    context '4*3の場合(掛け算)' do
      it '12を返すこと' do
        get '/calc' + '?4*3'
        json = JSON.parse(response.body)
        expect(json['data']).to eq 12
      end
    end

    context '50/5の場合(割り算)' do
      it '10を返すこと' do
        get '/calc' + '?50/5'
        json = JSON.parse(response.body)
        expect(json['data']).to eq 10
      end
    end

    context '2.6+4.7の場合(少数点を含む)' do
      it '小数点以下切り捨てで7を返すこと' do
        get '/calc' + '?2.6+4.7'
        json = JSON.parse(response.body)
        expect(json['data']).to eq 7
      end
    end

    context 'パラメータが正しくない場合' do
      it 'ステータス400を返すこと' do
        get '/calc'
        expect(response).to have_http_status(400)
      end
    end
  end
end
