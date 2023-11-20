# frozen_string_literal: true

#
# マテリアルの基底クラス
#
class Material
  def num_sample(_depth, _max_depth)
    # [depth - max_depth + 3, 1].max
    1
  end

  #
  # 反射情報を返す
  #
  # @param [Ray] ray 入射するレイ
  # @param [HitRecord] hrec 衝突情報
  #
  # @return [ScatteredRecord] 拡散情報
  #
  def scatter(ray, hrec)
    raise NotImplementedError
  end
end
