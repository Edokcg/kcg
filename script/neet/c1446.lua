--神圣之结界像(neet)
local s,id=GetID()
function s.initial_effect(c)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	c:RegisterEffect(e0)	
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCondition(s.con)
	e1:SetTarget(s.sumlimit)
	c:RegisterEffect(e1)
	--All monsters with that Attribute cannot activate their effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetCondition(s.con)
	e2:SetValue(s.aclimit)
	c:RegisterEffect(e2)
	--All monsters with that Attribute cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(s.con)
	e3:SetTarget(s.atktarget)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(s.thcon)
	e4:SetTarget(s.thtg2)
	e4:SetOperation(s.thop2)
	c:RegisterEffect(e4)
end
s.listed_names={37626500}
function s.filter(c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local mg=g:Filter(s.filter,nil)
	if #g>0 and #mg==0 then
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD&~(RESET_TOFIELD|RESET_LEAVE|RESET_TEMP_REMOVE),EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	end
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:GetAttribute()~=ATTRIBUTE_LIGHT
end
function s.con(e)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.aclimit(e,re,tp)
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.atktarget(e,c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.thfilter(c)
	return c:IsMonster() and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end