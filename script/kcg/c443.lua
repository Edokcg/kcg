--ハイドライブ・アクセラレーター
local s,id=GetID()
function s.initial_effect(c)
	--equip
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0x577))

	--Indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(function(e,c) return e:GetHandler():GetEquipTarget():IsAttribute(ATTRIBUTE_EARTH) end)
	c:RegisterEffect(e1)
	--immune
	local e2=e1:Clone()
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)

	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.discon)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
	
	local e4a=Effect.CreateEffect(c)
	e4a:SetType(EFFECT_TYPE_FIELD)
	e4a:SetCode(EFFECT_DISABLE)
	e4a:SetRange(LOCATION_SZONE)
	e4a:SetTargetRange(0,LOCATION_MZONE)
	e4a:SetCondition(s.discon2)
	e4a:SetTarget(s.distg2)
	c:RegisterEffect(e4a)
	local e4b=e4a:Clone()
	e4b:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4b:SetValue(0)
	c:RegisterEffect(e4b)

	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCost(s.descost)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
end
s.listed_series={0x577}

function s.efilter(e,re)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	return c:GetControler()~=re:GetOwnerPlayer()
		and (eqc:IsAttribute(ATTRIBUTE_WATER) and re:IsActiveType(TYPE_TRAP)
		or eqc:IsAttribute(ATTRIBUTE_FIRE) and re:IsActiveType(TYPE_SPELL)
		or eqc:IsAttribute(ATTRIBUTE_LIGHT) and re:IsActiveType(TYPE_MONSTER))
end

function s.tfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local eqc=e:GetHandler():GetEquipTarget()
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) 
		and g and g:IsExists(s.tfilter,1,eqc,tp) and Duel.IsChainDisablable(ev)
		and eqc:IsAttribute(ATTRIBUTE_WIND)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end

function s.discon2(e,tp,eg,ep,ev,re,r,rp)
	local eqc=e:GetHandler():GetEquipTarget()
	return eqc and eqc:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.distg2(e,c)
	local eqc=e:GetHandler():GetEquipTarget()
	return eqc and c:IsAttribute(eqc:GetAttribute()) and c~=eqc
end

function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local eqc=c:GetEquipTarget()
	e:SetLabel(1)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_LINK)>-1 and c:IsDestructable() and eqc:IsDestructable() and eqc:GetLink()>0 end
	Duel.Destroy(c,REASON_COST)
	if Duel.Destroy(eqc,REASON_COST)>0 then
		e:SetLabelObject(eqc)
	end
end
function s.spfilter(c,e,tp,link)
	return c:IsSetCard(0x577) and c:IsType(TYPE_LINK) and c:IsLink(link)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		if e:GetLabel()==0 and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_LINK)<=0 then return false end
		e:SetLabel(0)
		local eqc=c:GetEquipTarget()
		return eqc and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,eqc:GetLink()) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eqc=e:GetLabelObject()
	if not eqc then return end
	local link=eqc:GetLink()
	if not Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,link) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,link)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end