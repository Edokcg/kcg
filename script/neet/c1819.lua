--元素英雄 海魔新宇侠(neet)
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCode3(c,CARD_NEOS,17955766,43237273,false,false)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
	aux.EnableNeosReturn(c,CATEGORY_REMOVE,nil,s.retop) 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(function(e) return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA) end)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
end
s.listed_names={CARD_NEOS,80344569,43237273}
s.material_setcode={0x8,0x3008,0x9,0x1f}
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTargetRange(0,1)
	Duel.RegisterEffect(e1,tp)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_SZONE,nil)
	if chk==0 then return #mg~=#sg end
	local g=#mg>#sg and mg or sg
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	Duel.SetChainLimit(s.chlimit)
end
function s.chlimit(e,ep,tp)
	return tp==ep
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_SZONE,nil)
	if #mg==#sg then return end
	local g=#mg>#sg and mg or sg
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end