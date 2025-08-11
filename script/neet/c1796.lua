--绝望类星体(neet)
local s,id=GetID()
function s.initial_effect(c)
	--atk,def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(s.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)	
	--lv up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.lvcon)
	e3:SetOperation(s.lvop)
	c:RegisterEffect(e3)
	--Negate Spell/Trap Card or effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.negcon)
	e5:SetTarget(s.negtg)
	e5:SetOperation(s.negop)
	c:RegisterEffect(e5)
end
function s.value(e,c)
	return c:GetLevel()*300
end
function s.filter(c,tp)
	return c:IsMonster() and c:GetControler()~=tp and (c:HasLevel() or c:HasRank() or c:HasLink())
end
function s.lvcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler()
	return eg:IsExists(s.filter,1,nil,tp)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(s.filter,nil,tp)
	local lv=0
	for tc in aux.Next(g) do
		if tc:HasLevel() then
			lv=lv+tc:GetOriginalLevel()
		elseif tc:HasRank() then
			lv=lv+tc:GetOriginalRank()
		elseif tc:HasLink() then
			lv=lv+tc:GetLink()
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
	e2:SetValue(lv)
	c:RegisterEffect(e2)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep==1-tp and re:IsMonsterEffect() and e:GetHandler():GetLevel()>=5 and Duel.IsChainNegatable(ev)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local relation=rc:IsRelateToEffect(re)
	if chk==0 then return rc:IsAbleToRemove(tp) and e:GetHandler():GetLevel()>=5
		or (not relation and Duel.IsPlayerCanRemove(tp)) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if relation then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,rc:GetControler(),rc:GetLocation())
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,rc:GetPreviousLocation())
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFacedown() and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) and c:UpdateLevel(-4)~=0
		and Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end