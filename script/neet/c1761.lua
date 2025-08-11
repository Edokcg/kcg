--侵食融合用
local s,id=GetID()
function s.initial_effect(c)
	local params = {nil,nil,nil,nil,Fusion.ForcedHandler}
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.fucon)
	e3:SetTarget(Fusion.SummonEffTG(table.unpack(params)))
	e3:SetOperation(Fusion.SummonEffOP(table.unpack(params)))
	c:RegisterEffect(e3)
end
function s.fucon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(tp) and (Duel.IsMainPhase() or Duel.IsBattlePhase())
end
