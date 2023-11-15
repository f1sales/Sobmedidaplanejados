require 'ostruct'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_helpers'
require 'byebug'

RSpec.describe F1SalesCustom::Email::Parser do
  context 'when is from Website' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'website@sobmedidaplanejados.f1sales.net']
      email.subject = 'Orçamento'
      email.body = <<~BODY
        Nome: Testonildo Teste\nTelefone: 11-91234-4321\nQual ambiente você deseja mobiliar?: Apartamento\nPor qual loja deseja ser atendido(a)?: Anália Franco - Zona Leste SP\nQual pretensão de investimento?: 0\nDeixa uma nota para nosso consultor:\nAnexe suas medida ou planta:\n\n---\n\nData: 08/11/2023\nHorário: 12:46\nURL da página: https://sobmedidaplanejados.com.br/orcamento/\nAgente de usuário: Mozilla/5.0 (Windows NT 10.0; Win64; x64)\nAppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36\nIP remoto: 189.18.154.81\nDesenvolvido por: Elementor
      BODY

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains website novos as source name' do
      expect(parsed_email[:source][:name]).to eq(F1SalesCustom::Email::Source.all[0][:name])
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Testonildo Teste')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('11912344321')
    end

    it 'contains description' do
      expect(parsed_email[:description]).to eq('Ambiente: Apartamento; Loja: Anália Franco - Zona Leste SP; Pretensão de investimento: 0')
    end
  end
end
