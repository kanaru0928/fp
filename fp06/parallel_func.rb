# frozen_string_literal: true

#
# 並列用の関数基底クラス
#
class ParallelFunc
  def func
    raise NotImplementedError
  end
end
