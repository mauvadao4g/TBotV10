const path = require('path')
const { dockStart } = require('@nlpjs/basic');
const { resolve } = require('path');
const { rejects } = require('assert');

class  TBotZapNLP {
    
    train = async () => {
        const dir = path.resolve('NLP/','training.json')
        const dock = await dockStart({ use: ['Basic']});
        this.nlp = dock.get('nlp');
        await this.nlp.addCorpus('/etc/TerminusBot/TBotZap/NLP/training.json');
        await this.nlp.train();
    }

   answer =  (utterance) => {
        return new Promise( (resolve, rejects) => {
            this.nlp.process('pt', utterance).then((answer)=> {
              resolve(answer)

            })
        })
   }

}

module.exports.TBotZapNLP = new TBotZapNLP()