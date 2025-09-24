--Big Bang Dragon Blow
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,110000110,282)
	aux.AddEquipProcedure(c)
	
	local e00=Effect.CreateEffect(c)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e00)
	
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(876330,0))
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetTarget(s.target)
	e0:SetOperation(s.operation)
	c:RegisterEffect(e0)

	--Big Bang Attack!
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33725002,2))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.atkcon)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tar)
	e1:SetOperation(s.act)
	c:RegisterEffect(e1)
	
	--Equip Limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetValue(1)
	c:RegisterEffect(e3)

	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetTarget(s.target)
	e5:SetOperation(s.operation)
	c:RegisterEffect(e5)
end
s.listed_names={110000110,282}

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc~=e:GetHandler() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsLocation(LOCATION_SZONE) or c:IsFacedown() then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc)
end

function s.ffilter(c)
	return c:IsCode(170000153) and c:IsType(TYPE_SPELL)
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	local at=c:GetBattleTarget()
	return at and at:IsFaceup() and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,e:GetHandler():GetEquipTarget(),TYPE_MONSTER) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,e:GetHandler():GetEquipTarget(),TYPE_MONSTER)
	Duel.Release(g,REASON_COST)
end
function s.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	  local tc=g:GetFirst() 
	  local dam=0
	  while tc do
		  local atk=tc:GetAttack() 
		if atk<0 then atk=0 end 
		dam=dam+atk 
		tc=g:GetNext() 
	  end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0,nil)
	  Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam) 
end
function s.dfilter(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.act(e,tp,eg,ep,ev,re,r,rp)
   if not e:GetHandler():IsFaceup() then return end
   local g=Duel.GetMatchingGroup(s.dfilter,tp,0,LOCATION_MZONE,nil,e)
   local tc=g:GetFirst() 
   local dam=0
   while tc do
	local atk=tc:GetAttack() 
		if atk<0 then atk=0 end 
		dam=dam+atk 
		tc=g:GetNext() 
   end
   if Duel.Destroy(g,REASON_EFFECT)>0 then
   --local sum=g:GetSum(Card.GetAttack) 
   Duel.Damage(1-tp,dam,REASON_EFFECT)
end
end
