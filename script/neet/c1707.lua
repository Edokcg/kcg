--黄金乡的遗物（neet）
local s,id=GetID()
function s.initial_effect(c)
	 aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE))
--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(aux.tgoval)
	e3:SetCondition(s.atcon)
	c:RegisterEffect(e3)
	local e30=e3:Clone()
	e30:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e30:SetValue(aux.indoval)
	c:RegisterEffect(e30)
--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(s.damcon)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)

--Set
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_IGNITION)
	e20:SetCode(EVENT_FREE_CHAIN)
	e20:SetRange(LOCATION_GRAVE)
	e20:SetCountLimit(1,id+1)
	e20:SetCost(Cost.SelfBanish)
	e20:SetTarget(s.settg)
	e20:SetOperation(s.setop)
	c:RegisterEffect(e20)
end
s.listed_series={0x142,0x143}
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget():IsType(TYPE_NORMAL)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler()==e:GetHandler():GetEquipTarget() and e:GetHandler():GetEquipTarget():IsSetCard(0x142)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function s.setfilter(c)
	return c:IsSetCard(0x143) and c:IsSSetable() and not c:IsForbidden() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end