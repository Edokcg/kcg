--守護神官 瑪娜 (KDIY)
local s, id = GetID()
function s.initial_effect(c)
	
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
		
	--special summon
	local e01=Effect.CreateEffect(c)
	e01:SetDescription(aux.Stringid(71703785,0))
	e01:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e01:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e01:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e01:SetCode(EVENT_DRAW)
	e01:SetCost(s.spcost)
	e01:SetTarget(s.sptg1)
	e01:SetOperation(s.spop1)
	c:RegisterEffect(e01)	

	--墓地存在黑魔术师攻击力上升
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
	
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.efilter)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(96471335,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(s.spcon2)
	e4:SetTarget(s.sptg2)
	e4:SetOperation(s.spop2)
	c:RegisterEffect(e4)	
end
s.listed_names={900000074,46986414,CARD_DARK_MAGICIAN_GIRL}
-----------------------------------------------------------------------------------------
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
--------------------------------------------------
function s.atkfilter(c)
	local code=c:GetCode()
	return code==46986414 or code==30208479
end

function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.atkfilter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*500
end

function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function s.spfilter2(c,e,tp)
	return c:IsCode(CARD_DARK_MAGICIAN_GIRL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,tp,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)==0 then return end
	e:GetHandler():SetEntityCode(900000074, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true)
    aux.CopyCardTable(900000074,e:GetHandler())
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end