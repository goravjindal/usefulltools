#!/usr/bin/env python
import torch
import sys
de2en = torch.hub.load('pytorch/fairseq', 'transformer.wmt19.de-en.single_model', tokenizer='moses', bpe='fastbpe')


paraphrase = de2en.translate(sys.argv[1])
print(paraphrase)
