--奥利哈刚 七武神·暗之蚀(ZCG)
function c77240192.initial_effect(c)
		c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c77240192.spcon)
	c:RegisterEffect(e0)

	--Activate
	local e99=Effect.CreateEffect(c)
	e99:SetDescription(aux.Stringid(77240191,0))
	e99:SetType(EFFECT_TYPE_IGNITION)
	e99:SetRange(LOCATION_MZONE)
	e99:SetCountLimit(1)
	e99:SetTarget(c77240192.destg)
	e99:SetOperation(c77240192.desop)
	c:RegisterEffect(e99)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c77240192.con)
	e1:SetTarget(c77240192.tg)
	e1:SetOperation(c77240192.op)
	c:RegisterEffect(e1)
	 local e2=e1:Clone()
	e2:SetCode(EVENT_MSET)
	c:RegisterEffect(e2)
	local e5=e1:Clone()
	e5:SetCode(EVENT_SSET)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetCode(EVENT_CHAINING)
	c:RegisterEffect(e7)
end
function c77240192.con(e,tp,eg,ep,ev,re,r,rp)
	return  rp==1-tp
end
function c77240192.filter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c77240192.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c77240192.filter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,1,nil,e:GetHandler())end
end
function c77240192.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c77240192.filter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c77240192.spfilter(c)
return c:IsSetCard(0xa50) and c:IsLevelAbove(5)
end
function c77240192.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77240192.spfilter,tp,LOCATION_GRAVE,0,7,nil)
end

function c77240192.desfilter1(c,rc)
	return c:IsAttribute(rc)
end
function c77240192.desfilter3(c,rc)
	return c:IsAttribute(ATTRIBUTE_DARK)
end

function c77240192.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
		Duel.Hint(HINT_SELECTMSG,tp,563)
		local rc=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL-ATTRIBUTE_DARK)
		Duel.SetTargetParam(rc)
		e:GetHandler():SetHint(CHINT_ATTRIBUTE,rc)
		local g=Duel.GetMatchingGroup(c77240192.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,rc)
		local atk=0
		local des=0
		if #g>0 then
			atk=g:GetMinGroup(Card.GetAttack):GetFirst():GetAttack()
			des=g:GetMinGroup(Card.GetDefense):GetFirst():GetDefense()
		end
		e:SetLabel(atk,des)
end
function c77240192.desop(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetMatchingGroupCount(c77240192.desfilter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local atk,des=e:GetLabel()
	atk=atk*count
	des=des*count
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(atk)
	e:GetHandler():RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(des)
	e:GetHandler():RegisterEffect(e2)
end