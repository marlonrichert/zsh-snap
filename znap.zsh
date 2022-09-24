#!/bin/zsh
zmodload zsh/param/private

autoload -Uz ${${(%):-%x}:P:h}/scripts/init.zsh
{
  init.zsh
} always {
  unfunction init.zsh
}
